$ ->
  return unless isRepairPage()
  setTitle('报修')
  setupSidebar()
  $('div.containerDiv').first().show()
  updateAssetList('div#assets')
  setupAssetsDiv('div#assets')
  setupHistoryDiv('div#historyDiv', 120)
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
      when 'history'
        $("#{containerDiv} span#targetPartId").text('')
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
    statusIcon = ''
    historyIcon = ''
    if nodeDatum.kind is 'part'
      _status_css_class = ['success', 'warning', 'danger', 'info'][nodeDatum.status_code]
      statusIcon = "<span class='badge noCursor label-#{_status_css_class}'>#{nodeDatum.status}</span>"
      historyIcon = "<span class='badge' data-type='history' data-id='#{nodeDatum.id}'>历史</span>"

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
            <h4 class='media-heading'>#{nodeDatum.title}#{statusIcon}#{deleteIcon}#{historyIcon}</h4>
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
        $('div#historyDiv span#targetPartId').text($(this).data('id'))
        updateChart('div#historyDiv', {id: $(this).data('id')})
      when 'delete'
        _msg = '确认删除？'
        _msg = '警告：该设备的检点和部件将一同被删除\n' + _msg if $(this).data('kind') is 'asset'
        deleteTreeNode($(this)) if confirm(_msg)

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
      when 'createPart'
        $('div#managementData span#switchPartTo').text('')
        $('div#createPart button#btnCancelCreatePart').text('重置')
        $('div#createPart > h2:first').text('创建部件')
        $('div#managementData div#categorySelection').show()
        setupCreatePartForm('div#createPart')
      when 'editDeletePart'
        $('div#managementData div#partsTableDiv, div#managementData div#edit_delete_part_buttons').show()
        $('div#managementData div#createPart').hide()
        $('div#createPart button#btnCancelCreatePart').text('返回')
        $('div#createPart > h2:first').text('编辑部件')
        $('div#managementData div#categorySelection').hide()
        updatePartsTable('div#managementData div#editDeletePart')
      when 'attachPartToAsset'
        updateAssetsTable('div#managementData div#attachPartToAsset')
        updatePartsTable('div#managementData div#attachPartToAsset')
      when 'createManual'
        $('div#managementData span#switchManualTo').text('')
        $('div#createManual button#btnCancelCreateManual').text('重置')
        $('div#createManual > h2:first').text('创建工作指导')
        setupCreateManualForm('div#createManual')
      when 'editManual'
        $('div#managementData div#manualsTableDiv, div#managementData div#edit_manual_buttons').show()
        $('div#managementData div#createManual').hide()
        $('div#createManual button#btnCancelCreateManual').text('返回')
        $('div#createManual > h2:first').text('编辑工作指导')
        updateManualsTable('div#managementData div#editManual')
      when 'attachManualToAsset'
        updateAssetsTable('div#managementData div#attachManualToAsset')
        updateManualsTable('div#managementData div#attachManualToAsset')
    return

  setupCreatePartDiv()
  setupEditDeletePartDiv('div#managementData div#editDeletePart')
  setupCreateAssetDiv(setupBtnAddPartToAsset)
  setupDeleteAssetDiv('div#managementData div#deleteAsset')
  setupAttachPartToAssetDiv('div#managementData div#attachPartToAsset')
  setupCreateManualDiv('div#managementData div#createManual')
  setupEditManualDiv('div#managementData div#editManual')
  setupAttachManualToAssetDiv('div#managementData div#attachManualToAsset')

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
        showErrorPage(jqXHR.responseText)
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
    return false

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
      switch $('div#createPart > h2:first').text()
        when '编辑部件'
          updatePartsTable('div#managementData div#editDeletePart')

    return

  return

updatePartsTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/parts.json?ui=true'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'parts')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        columns = [
          { "sTitle": "ID" },
          { "sTitle": "名称" },
          { "sTitle": "条形码" },
          { "sTitle": "设备" },
          {
            "sTitle": "责任人",
            "sClass": "center"
          }
        ]
        if $("#{containerDiv} table#partsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#partsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#partsTable_wrapper").remove()
        $("#{containerDiv} div#partsTableDiv").append('<table id="partsTable"></table>')
        $("#{containerDiv} table#partsTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 3, 'desc' ]]
          'iDisplayLength': 5
          'aLengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, '全部']]

        oTable = $("#{containerDiv} table#partsTable").dataTable()
        oTable.fnSetColumnVis(0, false)
        $("#{containerDiv} table#partsTable > tbody").on(
          'click',
          'tr',
          ->
            oTable = $("#{containerDiv} table#partsTable").dataTable()
            oTable.$('tr.mediumSeaGreenBackground').removeClass('mediumSeaGreenBackground')
            $(this).addClass('mediumSeaGreenBackground')
            return
        )

        $("#{containerDiv} span#partsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} span#partsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout
  return

setupEditDeletePartDiv = (containerDiv) ->
  $("#{containerDiv} button#btnEditPart").click ->
    oTable = $("#{containerDiv} table#partsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择部件！'
    else
      row = oTable.fnGetData(_selectedTr[0])

      _switchPartTo = "#{containerDiv} div#partsTableDiv, #{containerDiv} div#edit_delete_part_buttons"
      $('div#managementData span#switchPartTo').text(_switchPartTo)
      $(_switchPartTo).hide()
      $('div#createPart').show()
      setupCreatePartForm('div#createPart')
      $.ajax
        url: getBaseURL() + "/parts/#{row[0]}.json?r=#{getRandomArbitrary(0, 10240)}" # disable browser cache for the same GET
        success: (data, textStatus, jqHXR) ->
          if jqHXR.status is 200
            $('div#createPart span#partId').text(data.id)
            $('div#createPart input#partName').val(data.name)
            $('div#createPart input#partDescription').val(data.description)
            $('div#createPart input#partBarcode').val(data.barcode)
            if data.default_assigned_id
              $('div#createPart input#part_assigned_to').val(data.default_assigned_user)
              $('div#createPart span#part_assigned_to_id').text(data.default_assigned_id)

          return
        error: (jqXHR, textStatus, errorThrown) ->
          showErrorPage(jqXHR.responseText)
          return
        ifModified: true,
        dataType: 'json',
        timeout: defaultAjaxCallTimeout

    return

  $("#{containerDiv} button#btnDeletePart").click ->
    oTable = $("#{containerDiv} table#partsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择部件！'
    else
      row = oTable.fnGetData(_selectedTr[0])
      deletePart(row[0], containerDiv) if confirm("您确定要删除部件 '#{row[1]}' 条形码 '#{row[2]}' 吗？")

    return

  return

deletePart = (partId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/parts/#{partId}.json"
    type: 'DELETE',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updatePartsTable(containerDiv)
      alert '部件已经成功删除！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    timeout: defaultAjaxCallTimeout
  return

setupAttachPartToAssetDiv = (containerDiv) ->
  $("#{containerDiv} button#btnAttachPartToAsset").click ->
    oTable1 = $("#{containerDiv} table#assetsTable").dataTable()
    _selectedTr1 = oTable1.$('tr.mediumSeaGreenBackground')
    if _selectedTr1.length is 0
      alert '请选择设备！'
      return

    oTable2 = $("#{containerDiv} table#partsTable").dataTable()
    _selectedTr2 = oTable2.$('tr.mediumSeaGreenBackground')
    if _selectedTr2.length is 0
      alert '请选择部件！'
      return

    row1 = oTable1.fnGetData(_selectedTr1[0])
    row2 = oTable2.fnGetData(_selectedTr2[0])
    attachPartToAsset(row2[0], row1[0], containerDiv) if confirm("连接部件 '#{row2[1]}' 条形码 '#{row2[2]}' 到设备 '#{row1[1]}' 条形码 '#{row1[2]}' 吗？")

    return

  return

attachPartToAsset = (partId, assetId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/assets/#{assetId}/attach_part?part=#{partId}"
    type: 'PUT',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updateAssetsTable(containerDiv)
      updatePartsTable(containerDiv)
      alert '已经成功连接部件到设备！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    timeout: defaultAjaxCallTimeout
  return

setupCreateManualDiv = (containerDiv) ->
  $("#{containerDiv} button#btnCancelCreateManual").click ->
    clearCreateManualForm(containerDiv)
    _switchManualTo = $('div#managementData span#switchManualTo').text()
    unless _switchManualTo is ''
      $('div#managementData span#switchManualTo').text('')
      $("#{_switchManualTo}").show()
      $('div#createManual').hide()
      switch $('div#createManual > h2:first').text()
        when '编辑工作指导'
          updatePartsTable('div#managementData div#editManual')

    return
  return

setupEditManualDiv = (containerDiv) ->
  $("#{containerDiv} button#btnEditManual").click ->
    oTable = $("#{containerDiv} table#manualsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择工作指导！'
      return

    row = oTable.fnGetData(_selectedTr[0])
    _switchManualTo = "#{containerDiv} div#manualsTableDiv, #{containerDiv} div#edit_manual_buttons"
    $('div#managementData span#switchManualTo').text(_switchManualTo)
    $(_switchManualTo).hide()
    $('div#createManual').show()
    setupCreateManualForm('div#createManual')
    $.ajax
      url: getBaseURL() + "/manuals/#{row[0]}.json?r=#{getRandomArbitrary(0, 10240)}" # disable browser cache for the same GET
      success: (data, textStatus, jqHXR) ->
        if jqHXR.status is 200
          $('div#createManual span#manualId').text(data.id)
          $('div#createManual input#manualName').val(data.name)
          $('div#createManual textarea#manualEntry').val(data.entry)

          if data.assets
            for a in data.assets
              asset = a.name
              asset += a.description if a.description
              $('div#createManual div#assets').append("<span class='lavenderBackground'>
                    <span class='hiddenSpan'>#{a.id}</span><i class='icon-remove'></i>#{asset}</span>")

          $('div#createManual div#assets > span > i').click(removeParent)

        return
      error: (jqXHR, textStatus, errorThrown) ->
        showErrorPage(jqXHR.responseText)
        return
      ifModified: true,
      dataType: 'json',
      timeout: defaultAjaxCallTimeout

    return

  return

setupCreateManualForm = (containerDiv) ->
  $('div#createManual button#btnCreateManual').unbind('click')
  $('div#createManual button#btnCreateManual').click ->
    requestType = null
    _relativeUrl = null
    switch $('div#createManual > h2:first').text()
      when '创建工作指导'
        requestType = 'POST'
        _relativeUrl = '/manuals.json'
      when '编辑工作指导'
        requestType = 'PUT'
        _relativeUrl = "/manuals/#{$('div#createManual span#manualId').text()}.json"
      else
        alert "Wrong createManual title #{$('div#createManual > h2:first').text()}"
        return

    manualInfo = {}
    return unless validateCreateManualForm('div#createManual', manualInfo)
    manualInfo['assets'] = ($(span).children('span').text() for span in $('div#createManual div#assets > span'))
    $.ajax
      url: getBaseURL() + _relativeUrl
      type: requestType,
      contentType: 'application/json',
      data: JSON.stringify(manualInfo),
      dataType: 'json',
      success: (data, textStatus, jqHXR) ->
        clearCreateManualForm(containerDiv)
        _switchManualTo = $('div#managementData span#switchManualTo').text()
        unless _switchManualTo is ''
          $('div#managementData span#switchManualTo').text('')
          $("#{_switchManualTo}").show()
          $('div#createManual').hide()

        switch requestType
          when 'POST'
            alert '工作指导创建成功'
          when 'PUT'
            alert '工作指导编辑成功'
            updateManualsTable('div#managementData div#editManual')

        return
      error: (jqXHR, textStatus, errorThrown) ->
        showErrorPage(jqXHR.responseText)
        return
      timeout: defaultAjaxCallTimeout

    return
  return

validateCreateManualForm = (containerDiv, manualInfo) ->
  manualInfo = {} unless manualInfo
  $manualName = $("#{containerDiv} input#manualName")
  if isInputValueEmpty($manualName)
    alert '请填写名称！'
    return false

  $manualEntry = $("#{containerDiv} textarea#manualEntry")
  if isInputValueEmpty($manualEntry)
    alert '请填写内容！'
    return false

  manualInfo['name'] = $manualName.val()
  manualInfo['entry'] = $manualEntry.val()
  true

updateManualsTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/manuals.json?ui=true'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'manuals')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for record in data
          record[3] = joinStringArrayWithBR(record[3])

        columns = [
          { "sTitle": "ID" },
          { "sTitle": "名称" },
          { "sTitle": "内容" },
          { "sTitle": "设备" }
        ]
        if $("#{containerDiv} table#manualsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#manualsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#manualsTable_wrapper").remove()
        $("#{containerDiv} div#manualsTableDiv").append('<table id="manualsTable"></table>')
        $("#{containerDiv} table#manualsTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 1, 'asc' ]]
          'iDisplayLength': 5
          'aLengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, '全部']]

        oTable = $("#{containerDiv} table#manualsTable").dataTable()
        oTable.fnSetColumnVis(0, false)
        $("#{containerDiv} table#manualsTable > tbody").on(
            'click',
            'tr',
          ->
            oTable = $("#{containerDiv} table#manualsTable").dataTable()
            oTable.$('tr.mediumSeaGreenBackground').removeClass('mediumSeaGreenBackground')
            $(this).addClass('mediumSeaGreenBackground')
            return
        )

        $("#{containerDiv} span#manualsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} span#manualsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

clearCreateManualForm = (containerDiv) ->
  resetToPlaceholderValue($("#{containerDiv} input"))
  $("#{containerDiv} textarea").val('')
  $("#{containerDiv} div#assets").html('')
  return

setupAttachManualToAssetDiv = (containerDiv) ->
  $("#{containerDiv} button#btnAttachManualToAsset").click ->
    oTable1 = $("#{containerDiv} table#assetsTable").dataTable()
    _selectedTr1 = oTable1.$('tr.mediumSeaGreenBackground')
    if _selectedTr1.length is 0
      alert '请选择设备！'
      return

    oTable2 = $("#{containerDiv} table#manualsTable").dataTable()
    _selectedTr2 = oTable2.$('tr.mediumSeaGreenBackground')
    if _selectedTr2.length is 0
      alert '请选择工作指导！'
      return

    row1 = oTable1.fnGetData(_selectedTr1[0])
    row2 = oTable2.fnGetData(_selectedTr2[0])
    setManualToAsset(row2[0], row1[0], containerDiv) if confirm("指定设备 '#{row1[1]}' 条形码 '#{row1[2]}' 的工作指导为 '#{row2[1]}' 吗？")

    return

  return

setManualToAsset = (manualId, assetId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/assets/#{assetId}/set_manual?manual=#{manualId}"
    type: 'PUT',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updateAssetsTable(containerDiv)
      updateManualsTable(containerDiv)
      alert '已经成功指定设备的工作指导！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    timeout: defaultAjaxCallTimeout
  return

moveCalendar = (containerDiv, days) ->
  startTimePicker = $("#{containerDiv} div#startTime").data('datetimepicker')
  endTimePicker = $("#{containerDiv} div#endTime").data('datetimepicker')

  startTime = startTimePicker.getLocalDate()
  endTime = endTimePicker.getLocalDate()

  today = getToday()
  if endTime.addDays(days) > today
    _shift = parseInt((today - endTime) / 86400000) # 24*60*60*1000 hours*minutes*seconds*milliseconds
    startTimePicker.setLocalDate(startTime.addDays(_shift))
    endTimePicker.setLocalDate(today)
  else
    startTimePicker.setLocalDate(startTime.addDays(days))
    endTimePicker.setLocalDate(endTime.addDays(days))

  return

setupMoveCalendarBtn = (containerDiv, maxDays) ->
  $("#{containerDiv} span#btnBackwardCalendar").click ->
    moveCalendar(containerDiv, -maxDays)
    $("#{containerDiv} button#barcodeButton").trigger('click')
    return

  $("#{containerDiv} span#btnForwardCalendar").click ->
    moveCalendar(containerDiv, maxDays)
    $("#{containerDiv} button#barcodeButton").trigger('click')
    return

  return

setupHistoryDiv = (containerDiv, maxDays) ->
  setupCalendar(containerDiv, maxDays, maxDays)
  setupMoveCalendarBtn(containerDiv, maxDays)
  $("#{containerDiv} input#barcodeInput").val('')
  $("#{containerDiv} button#barcodeButton").click ->
    _val = $("#{containerDiv} input#barcodeInput").val()
    unless $.trim(_val)
      if $("#{containerDiv} span#targetPartId").text() is ''
        alert '条形码不能为空！'
      else
        updatePartChart(containerDiv, {id: $("#{containerDiv} span#targetPartId").text()})
      return

    updateChart(containerDiv, {barcode: _val})
    return

  $("#{containerDiv} button#btnPartSelection").click ->
    updatePartChart(containerDiv, {id: $("#{containerDiv} select#partSelection").val()})
    return
  return

updateChart = (containerDiv, params) ->
  $("#{containerDiv} div#chartDiv").html('')
  $("#{containerDiv} div.historyBanner").hide()

  if params.barcode
    $.ajax
      url: getBaseURL() + "/assets/#{params.barcode}.json?barcode=true"
      success: (data, textStatus, jqHXR) ->
        if jqHXR.status is 200
          if data.parts.length == 1
            updateChart(containerDiv, {id: data.parts[0].id})
            return

          $("#{containerDiv} div#partSelectionBanner").show()
          $partSelection = $("#{containerDiv} div#partSelectionBanner select#partSelection")
          $partSelection.html('')
          for part in data.parts
            $partSelection.append("<option value='#{part.id}'>#{part.name} #{part.description}</option>")

        return
      error: (jqXHR, textStatus, errorThrown) ->
        if jqXHR.status is 404
          updatePartChart(containerDiv, params)
        else
          showErrorPage(jqXHR.responseText)

        return
      dataType: 'json',
      timeout: defaultAjaxCallTimeout
  else
    updatePartChart(containerDiv, params)

  return

updatePartChart = (containerDiv, params) ->
  $("#{containerDiv} div#chartDiv").html('')
  $("#{containerDiv} div#noHistoryBanner, #{containerDiv} div#errorBanner, #{containerDiv} div#infoBanner").hide()

  start_time = getDatetimePickerEpoch("#{containerDiv} div#startTime")
  end_time = getDatetimePickerEpoch("#{containerDiv} div#endTime") + 86400 # Add one day for 86400 seconds (60 * 60 * 24)
  request_params = { check_time: "#{start_time}..#{end_time}" }
  _id = params.id
  _barcode = params.barcode

  unless _barcode is undefined
    request_params.barcode = true
    _id = _barcode

  $.ajax
    url: getBaseURL() + "/parts/#{_id}/history.json?chart=true"
    data: request_params
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $('div#errorBanner, div#infoBanner').hide()
        _part = data.part
        title = "#{_part.name}   #{_part.description}"
        $("#{containerDiv} input#barcodeInput").val(_part.barcode)
        if data.result.length is 0
          $('div#noHistoryBanner').text("部件\"#{title}\"没有历史纪录").show()
        else
          $('div#noHistoryBanner').hide()
          renderFilledAreaChart('chartDiv', title, data.result)

      return
    error: (jqXHR, textStatus, errorThrown) ->
      if jqXHR.status is 404
        $('div#noHistoryBanner,div#infoBanner').hide()
        $('div#errorBanner').text(jqXHR.responseJSON.error)
        $('div#errorBanner').show()
      else
        showErrorPage(jqXHR.responseText)

      return
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

renderFilledAreaChart = (chartId, title, data) ->
  _lines = [[],[],[]]
  _ticks = []
  for datum in data
    _range = dateToShortString(new Date(datum.time * 1000))
    _ticks.push(_range)
    for _line, i in _lines
      if i is datum.status - 1
        _line.push(1)
      else
        _line.push(0)

  _trimmed_ticks = _ticks.slice()
  for i in [0..(_trimmed_ticks.length - 1)]
    _trimmed_ticks[i] = ' ' unless i % 7 is 0

  _series = [{label: '保养'}, {label: '报修'}, {label: '其他'}]
  _plot_setting =
    title: title
    stackSeries: true
    seriesDefaults:
      fill: true
      fillToZero: true
      rendererOptions:
        highlightMouseDown: true
    series: _series
#    seriesColors: ['rgb(248, 148,​ 6)', 'rgb(217,​ 83,​ 79)', 'rgb(135,​ 206,​ 250)']
    seriesColors: ['#F89406', '#D9534F', '#87CEFA']
    highlighter:
      tooltipContentEditor: (str, seriesIndex, pointIndex) ->
        _ticks[pointIndex]
      show: true,
      showMarker: true,
      tooltipLocation: 'se'
    axesDefaults:
      tickRenderer: $.jqplot.CanvasAxisTickRenderer
    axes:
      xaxis:
        renderer: $.jqplot.CategoryAxisRenderer
        ticks: _trimmed_ticks
        tickOptions:
          angle: chart_x_tick_angle
      yaxis:
        ticks: [[0, '正常'], [1, '维护']]
        padMin: 0
        min: 0
        padMax: 2
        max: 2
    legend:
      show: true,
      location: 'ne',
      placement: 'outside'

  $.jqplot(
    chartId,
    _lines,
    _plot_setting
  )
  return