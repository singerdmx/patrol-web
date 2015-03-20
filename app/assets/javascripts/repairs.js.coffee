$ ->
  return unless isRepairPage()
  setTitle('报修')
  setupSidebar()
  $('div.containerDiv').first().show()
  updateAssetList('div#assets')
  setupAssetsDiv('div#assets')

  removeFlashNotice()

  # Admn tabs
  return unless getPageTitle() is '报修 | 管理员'

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

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

setupAssetListClick = (containerDiv) ->
  return

setupAssetsDiv  = (containerDiv) ->
  $("#{containerDiv} div#assetList, #{containerDiv} div#assetDetails").height($(document).height() * 0.8)
  return