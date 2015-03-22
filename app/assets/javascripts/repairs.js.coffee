$ ->
  return unless isRepairPage()
  setTitle('报修')
  setupSidebar()
  $('div.containerDiv').first().show()
  updateAssetList('div#assets')
  setupAssetsDiv('div#assets')
  setupProblemsDiv('div#problemsDiv')

  removeFlashNotice()

  # Admn tabs
  return unless getPageTitle() is '报修 | 管理员'

  setupManageUsersDiv('div#manageUsersDiv')
  setupManageDataDiv()
  setupManageContactsDiv('div#manageContactsDiv')
  return

isRepairPage = ->
  _pageTitle = getPageTitle()
  return true if _pageTitle in ['报修 | 用户', '报修 | 管理员', '报修 | 高级用户', '报修 | 维修工']
  false

setupSidebar = ->
  $('div#sidebar > div.close_box').click ->
    $('div#sidebar > ul').toggle()
    $('div#sidebar').toggleClass('transparentBackground')
    if $(this).hasClass('close_box')
      $(this).addClass('open_box').removeClass('close_box')
    else
      $(this).addClass('close_box').removeClass('open_box')
    return
  $('div#sidebar > ul > li').click (e) ->
    $('#sidebar ul li.active').removeClass('active')
    $(this).addClass('active')
    id = $(this).attr('id')
    containerDiv = "div##{id}Div"
    $('div.containerDiv').hide()
    $(containerDiv).show()
    switch id
      when 'assets'
        updateAssetList(containerDiv)
      when 'problems'
        updateProblemsTable(containerDiv)
      when 'manageUsers'
        updateUsersTable(containerDiv)
      when 'manageContacts'
        $("#{containerDiv} div#addEditContactDiv, #{containerDiv} button#btnAddNewContact, #{containerDiv} button#btnEditContact").hide()
        updateContactsTable(containerDiv)
    return

  return

updateAssetList = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/assets.json'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'assets')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        _$ul = $("div#assetsDiv ul.list-group")
        _$ul.html('')

        for asset in data
          _$ul.append "
                      <li class='list-group-item' data-id='#{asset.id}'>
                        <span class='badge'>#{asset.parts.length}</span>
                        #{asset.name}</li>"

        setupAssetListClick(containerDiv)
        $("#{containerDiv} > span#assetsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#assetsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

        renderTreeView('/assets.json', "#{containerDiv} div#assetsTree",
          null, {parts_tree_view: true}, true, true, buildTreeNode, bindTreeViewClick)
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

setupAssetsDiv  = (containerDiv) ->
  $("#{containerDiv} div#assetList, #{containerDiv} div#assetDetails").height($(document).height() * 0.8)
  $("#{containerDiv} ul#assetListGroup").sortable(
    helper : 'clone'
    start: (event, ui) ->
      start_pos = ui.item.index()
      ui.item.data('start_pos', start_pos)
    update: (event, ui) ->
      start_pos = ui.item.data('start_pos')
      asset_id = $(ui.item[0]).data('id')
      for _li, i in $("#{containerDiv} ul#assetListGroup > li")
        if $(_li).data('id') is asset_id
          end_pos = i
          _treeNode = $("#{containerDiv} div#assetsTree > ul[data-id='#{asset_id}']")
          if start_pos < end_pos
            # move down
            if end_pos + 2 > $("#{containerDiv} div#assetsTree > ul").size()
              # move it to the last
              ($("#{containerDiv} div#assetsTree > ul:last")).after(_treeNode)
            else
              # end_pos + 2 since we need to count _treeNode itself
              $("#{containerDiv} div#assetsTree > ul:nth-child(#{end_pos+2})").before(_treeNode)
          else
            # move up
            $("#{containerDiv} div#assetsTree > ul:nth-child(#{end_pos+1})").before(_treeNode)

          break

      return
  )
  setupTreeViewControlButtons(containerDiv)

  return

setupAssetListClick = (containerDiv) ->
  $("#{containerDiv} ul.list-group > li.list-group-item").click ->
    $(this).toggleClass('greenBackground')
    asset_id = $(this).data('id')
    $("#{containerDiv} div#assetsTree > ul[data-id='#{asset_id}']").toggle()
    return

  return

buildTreeNode = (parent, data, showDeleteIcon) ->
  for nodeDatum, i in data
    historyIcon = ''
    historyIcon = "<span class='badge' data-type='history' data-id='#{nodeDatum.id}'>历史</span>" if nodeDatum.kind is 'part'
    deleteIcon = ''
    if getPageTitle() is '报修 | 管理员' and showDeleteIcon
      deleteIcon = "<span class='badge' data-type='delete' data-id='#{nodeDatum.id}' data-kind='#{nodeDatum.kind}'>删除</span>"
    parent.append "
        <ul class='media-list' data-id='#{nodeDatum.id}'>
          <li class='media'>
            <a class='pull-left'>
              <img src='/assets/#{nodeDatum.icon}' class='media-object mediaListIcon' data-id='#{nodeDatum.id}'/>
            </a>
            <div class='media-body'>
            <h4 class='media-heading'>#{nodeDatum.title}#{deleteIcon}#{historyIcon}</h4>
            <span>#{nodeDatum.description}</span>"

    $ul = $(parent.children('ul')[i])
    buildTreeNode($ul.find('li > div.media-body'), nodeDatum.children, showDeleteIcon)
  return

bindTreeViewClick = (containerDiv) ->
  $("#{containerDiv} ul.media-list > li.media > a.pull-left").click ->
    img = $(this).children('img.media-object.mediaListIcon')
    src = img.attr('src')
    pic = src.split('/').pop()
    switch pic
      when 'minus.png'
        img.attr('src', src.replace(/minus.png/, 'plus.png'))
      when 'plus.png'
        img.attr('src', src.replace(/plus.png/, 'minus.png'))

    $(this).next('div.media-body').children('ul.media-list').toggle()

    return

  $("#{containerDiv} ul.media-list > li.media span.badge").click ->
    switch $(this).data('type')
      when 'history'
        $('div#sidebar ul > li#history').trigger('click')
      when 'delete'
        deleteTreeNode($(this)) if confirm("确认删除？")

    return

  return

setupBtnAddPartToAsset = ->
  $('div#createAsset button#btnAddPartToAsset').click ->
    $('div#managementData span#switchPartTo').text('div#createAsset')
    clearCreatePartForm()
    $('div#createAsset').hide()
    $('div#createPart').show()
    setupCreatePartForm('div#createPart')
  return

setupManageDataDiv = ->
  $('div#managementButtons ul.dropdown-menu > li > a').click ->
    $('div#managementData > div').hide()
    divId = $(this).data('div')
    $("div#managementData > div##{divId}").show()
    switch divId
      when 'createAsset'
        $('div#createPart button#btnCancelCreatePart').text('重置')
        $('div#createPart > h2:first').text('创建部件')
        $('div#managementData div#categorySelection').show()
      when 'deleteAsset'
        updateAssetsTable('div#managementData div#deleteAsset')
#      when 'createPart'
#        $('div#managementData span#switchPartTo').text('')
#        $('div#createPart button#btnCancelCreatePart').text('重置')
#        $('div#createPart > h2:first').text('创建部件')
#        $('div#managementData div#categorySelection').show()
#        setupCreatePartForm('div#createPart')
#      when 'editDeletePart'
#        $('div#managementData div#partsTableDiv, div#managementData div#edit_delete_part_buttons').show()
#        $('div#createPart').hide()
#        $('div#createPart button#btnCancelCreatePart').text('返回')
#        $('div#createPart > h2:first').text('编辑部件')
#        $('div#managementData div#categorySelection').hide()
#        updatePartsTable('div#managementData div#editDeletePart')
#      when 'attachPartToAsset'
#        updateAssetsTable('div#managementData div#attachPartToAsset')
#        updatePartsTable('div#managementData div#attachPartToAsset')
    return

  setupCreatePartDiv()
#  setupEditDeletePartDiv('div#managementData div#editDeletePart')
  setupCreateAssetDiv(setupBtnAddPartToAsset)
  setupDeleteAssetDiv('div#managementData div#deleteAsset')
#  setupAttachPartToAssetDiv('div#managementData div#attachPartToAsset')

  return

clearCreatePartForm = ->
  resetToPlaceholderValue($('div#createPart input'))
  $('div#assignedToSelection input#part_assigned_to').val('')
  $('div#assignedToSelection span#part_assigned_to_id').text('')
  return

setupCreatePartForm = (containerDiv) ->
  _suggestions = []
  setupAutocompleteInput('/users.json', 'name', containerDiv,
    'input#part_assigned_to',
    _suggestions, $("#{containerDiv} span#part_assigned_to_id"))

  $('div#createPart button#btnCreatePart').unbind('click')
  $('div#createPart button#btnCreatePart').click ->
    requestType = null
    _relativeUrl = null
    switch $('div#createPart > h2:first').text()
      when '创建部件'
        requestType = 'POST'
        _relativeUrl = '/parts.json'
      when '编辑部件'
        requestType = 'PUT'
        _relativeUrl = "/parts/#{$('div#createPart span#partId').text()}.json"
      else
        alert "Wrong createPart title #{$('div#createPart > h2:first').text()}"
        return

    partInfo = {}
    return unless validateCreatePartForm('div#createPart', partInfo, _suggestions)
    $partDescription = $('div#createPart input#partDescription')
    partInfo['description'] = $partDescription.val() unless isInputValueEmpty($partDescription)
    $partBarcode = $('div#createPart input#partBarcode')
    partInfo['barcode'] = $partBarcode.val() unless isInputValueEmpty($partBarcode)

    $.ajax
      url: getBaseURL() + _relativeUrl
      type: requestType,
      contentType: 'application/json',
      data: JSON.stringify(partInfo),
      dataType: 'json',
      success: (data, textStatus, jqHXR) ->
        clearCreatePartForm()
        _switchPartTo = $('div#managementData span#switchPartTo').text()
        unless _switchPartTo is ''
          $('div#managementData span#switchPartTo').text('')
          $("#{_switchPartTo}").show()
          $('div#createPart').hide()
          switch requestType
            when 'POST'
              $('div#addedPartDiv').append("<span class='lavenderBackground'>
                                                      <span class='hiddenSpan'>#{data.id}</span>#{data.name}</span>")

        switch requestType
          when 'POST'
            alert '部件创建成功'
          when 'PUT'
            alert '部件编辑成功'
            updatePartsTable('div#managementData div#editDeletePart')

        return
      error: (jqXHR, textStatus, errorThrown) ->
        alert jqXHR.responseJSON.message
        return
      timeout: defaultAjaxCallTimeout
  return

validateCreatePartForm = (containerDiv, partInfo, suggestions) ->
  partInfo = {} unless partInfo
  partName = $("#{containerDiv} input#partName")
  if isInputValueEmpty(partName)
    alert '请填写名称！'
    return false

  partInfo['name'] = partName.val()
  assignedUser = $("#{containerDiv} input#part_assigned_to").val().trim()
  assignedToId = $("#{containerDiv} span#part_assigned_to_id").text()
  valid = true

  if assignedUser is ''
    $("#{containerDiv} span#part_assigned_to_id").text('')
    assignedToId = ''
  else
    _u = $.grep(
      suggestions,
    (e) ->
      e.data.toString() is assignedToId
    )

    valid = false unless _u.length > 0 and _u[0].value is assignedUser

  unless valid
    alert '责任人填写错误！'
    return

  partInfo['default_assigned_id'] = assignedToId
  true

setupCreatePartDiv = ->
  $('div#createPart button#btnCancelCreatePart').click ->
    clearCreatePartForm()
    _switchPartTo = $('div#managementData span#switchPartTo').text()
    unless _switchPartTo is ''
      $('div#managementData span#switchPartTo').text('')
      $("#{_switchPartTo}").show()
      $('div#createPart').hide()
#      switch $('div#createPart > h2:first').text()
#        when '编辑部件'
#          updatePartsTable('div#managementData div#editDeletePart')
      return

    return

  return
