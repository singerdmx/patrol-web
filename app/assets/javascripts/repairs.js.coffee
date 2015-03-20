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
    historyIcon = "<span class='badge' data-type='history' data-id='#{nodeDatum.id}'>历史</span>" if nodeDatum.kind is 'point'
    moveOutIcon = ''
    if nodeDatum.kind is 'part' and getPageTitle() is '报修 | 管理员'
      moveOutIcon = "<span class='badge' data-type='moveOut' data-id='#{nodeDatum.id}'>移出</span>"
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
            <h4 class='media-heading'>#{nodeDatum.title}#{deleteIcon}#{historyIcon}#{moveOutIcon}</h4>
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
      when 'moveOut'
        confirm("确认移出？")
      when 'delete'
        confirm("确认删除？")

    return

  return