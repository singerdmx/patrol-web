fade_speed = 400

$ ->
  return unless isUserPage()
  setTitle('巡检')
  setupSidebar()
  $('div.containerDiv').first().show()
  setupRecordsDiv('div#preferencesDiv', 1, { preference: true })
  updateRecordsTable('div#preferencesDiv', { preference: true })
  setupRoutesDiv('div#routes')
  setupFactoriesDiv('div#factories')
  setupSessionsDiv('div#sessionsDiv', 1)
  setupRecordsDiv('div#recordsDiv', 1)
  setupHistoryDiv('div#historyDiv')
  setupProblemsDiv('div#problemsDiv')

  # Check on exiting page
  window.onbeforeunload = confirmExit
  removeFlashNotice()

  # Admn tabs
  return unless getPageTitle() is '巡检 | 管理员'

  setupManageUsersDiv('div#manageUsersDiv')
  setupManageDataDiv()
  setupManageContactsDiv('div#manageContactsDiv')
  return

isUserPage = ->
  _pageTitle = getPageTitle()
  return true if _pageTitle in ['巡检 | 巡检员', '巡检 | 管理员', '巡检 | 高级用户']
  false

# users show
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
      when 'routes'
        updateFactoriesTree(containerDiv) if $('div#factories').is(':visible')
        updateRouteList("#{containerDiv} div#routes")
      when 'preferences'
        updateRecordsTable(containerDiv, { preference: true })
      when 'sessions'
        updateSessionsTable(containerDiv)
      when 'records'
        updateRecordsTable(containerDiv)
      when 'manageUsers'
        updateUsersTable(containerDiv)
      when 'manageContacts'
        $("#{containerDiv} div#addEditContactDiv, #{containerDiv} button#btnAddNewContact, #{containerDiv} button#btnEditContact").hide()
        updateContactsTable(containerDiv)
      when 'problems'
        updateProblemsTable(containerDiv)
    return
  return

setupFactoriesDiv = (containerDiv) ->
  setupTreeViewControlButtons(containerDiv)
  $("#{containerDiv} button#toRoutes").click ->
    _selectedRouteIds = []
    for _li in $('div#routesDiv div#routeListInFactory ul.list-group > li:visible')
      _selectedRouteIds.push($(_li).data('id'))

    if _selectedRouteIds.length is 0
      alert '没有路线选中'
      return

    $('div#routesDiv div#routeList h3.panel-title').text($('div#routesDiv div#routeListInFactory h3.panel-title').text())
    $('div#routesDiv div#routeList ul.list-group > li.greenBackground').trigger('click')
    $('div#routesDiv div#routeList ul.list-group > li').hide()
    for id in _selectedRouteIds
      $("div#routesDiv div#routeList ul#routeListGroup > li.list-group-item[data-id='#{id}']").show()

    $('div#factories').hide('drop', {}, fade_speed,
      ->
        $('div#routes').show('drop', {direction: 'right'}, fade_speed)
        return
    )
    return

  return

setupRoutesDiv  = (containerDiv) ->
  $("#{containerDiv} div#routeList, #{containerDiv} div#routeDetails").height($(document).height() * 0.8)
  $("#{containerDiv} ul#routeListGroup").sortable(
    helper : 'clone'
    start: (event, ui) ->
      start_pos = ui.item.index()
      ui.item.data('start_pos', start_pos)
    update: (event, ui) ->
      start_pos = ui.item.data('start_pos')
      route_id = $(ui.item[0]).data('id')
      for _li, i in $("#{containerDiv} ul#routeListGroup > li")
        if $(_li).data('id') is route_id
          end_pos = i
          _treeNode = $("#{containerDiv} div#routesTree > ul[data-id='#{route_id}']")
          if start_pos < end_pos
            # move down
            if end_pos + 2 > $("#{containerDiv} div#routesTree > ul").size()
              # move it to the last
             ($("#{containerDiv} div#routesTree > ul:last")).after(_treeNode)
            else
              # end_pos + 2 since we need to count _treeNode itself
              $("#{containerDiv} div#routesTree > ul:nth-child(#{end_pos+2})").before(_treeNode)
          else
            # move up
            $("#{containerDiv} div#routesTree > ul:nth-child(#{end_pos+1})").before(_treeNode)

          break

      return
  )
  setupTreeViewControlButtons(containerDiv)
  $("#{containerDiv} button#toFactories").click ->
    $('div#routes').hide('drop', {direction: 'right'}, fade_speed,
      ->
        $('div#factories').show('drop', {}, fade_speed)
        return
    )
    return

  $('div#routesTreeControlButtons button#updatePreferences').click ->
    updatePreferences(containerDiv)
    $("#{containerDiv} > span#preferencesUpdated").text('false')
    return
  return

updateFactoriesTree = (containerDiv) ->
  renderTreeView('/factories.json', "#{containerDiv} div#factoriesTree",
    "#{containerDiv} span#factories", null, false, false, buildTreeNode, bindTreeViewClick)
  $('div#routesDiv div#routeListInFactory ul.list-group > li').hide()
  $('div#routesDiv div#factoriesTree li.lawnGreenBackground').removeClass('lawnGreenBackground')
  $('div#routesDiv div#routeListInFactory h3.panel-title').text('路线')
  return

updateRouteList = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/routes.json'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'routes')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        _$ul = $("div#routesDiv ul.list-group")
        _$ul.html('')

        for route in data
          _$ul.append "
            <li class='list-group-item' data-id='#{route.id}' data-group='#{route.area_id}'>
              <span class='badge'>#{route.points.length}</span>
              #{route.name}</li>"

        $('div#routesDiv div#routeListInFactory ul.list-group > li').hide()

        setupRouteListClick(containerDiv)
        $("#{containerDiv} > span#routesIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#routesIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

        renderTreeView('/routes.json', "#{containerDiv} div#routesTree",
          null, {group_by_asset: true}, true, true, buildTreeNode, bindTreeViewClick)
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

setupRouteListClick = (containerDiv) ->
  $("#{containerDiv} ul.list-group > li.list-group-item").click ->
    $(this).toggleClass('greenBackground')
    route_id = $(this).data('id')
    $("#{containerDiv} div#routesTree > ul[data-id='#{route_id}']").toggle()
    return

  return

updatePreferences = (containerDiv) ->
  _preferences = new HashSet()
  for img in $("#{containerDiv} div#routesTree ul.media-list > li.media > a.pull-left > img[src$='care.png']")
    id = $(img).data('id')
    _preferences.add(parseInt(id))

  preferences = []
  for preference in _preferences.values()
    preferences.push(preference)

  $.ajax
    url: getBaseURL() + '/user_preferences.json'
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({ preferences: preferences }),
    dataType: 'text',
    success: (data, textStatus, jqHXR) ->
      alert '更新成功'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    timeout: defaultAjaxCallTimeout

  return

findParentRoute = (elem) ->
  parent = elem.parent()
  return elem if parent.is('div') and parent.attr('id') is "routesTree"
  findParentRoute(parent)

buildTreeNode = (parent, data, showDeleteIcon) ->
  for nodeDatum, i in data
    historyIcon = ''
    historyIcon = "<span class='badge' data-type='history' data-id='#{nodeDatum.id}'>历史</span>" if nodeDatum.kind is 'point'
    moveOutIcon = ''
    if nodeDatum.kind is 'point' and getPageTitle() is '巡检 | 管理员'
      moveOutIcon = "<span class='badge' data-type='moveOut' data-id='#{nodeDatum.id}'>移出</span>"
    deleteIcon = ''
    if getPageTitle() is '巡检 | 管理员' and showDeleteIcon
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
      when 'tool.png', 'care.png'
        $('div#routes > span#preferencesUpdated').text('true')
        syncSamePointImg(containerDiv, img, pic)
      when 'location.png'
        $('div#routesDiv div#routeListInFactory ul.list-group > li').hide()
        id = img.data('id')
        $('div#routesDiv div#factoriesTree li.lawnGreenBackground').removeClass('lawnGreenBackground')
        img.parent().parent().addClass('lawnGreenBackground')
        $("div#routesDiv ul#routeListGroupInFactory > li.list-group-item[data-group='#{id}']").show()
        $('div#routesDiv div#routeListInFactory h3.panel-title').text($(this).next().children('span').text())

    $(this).next('div.media-body').children('ul.media-list').toggle()

    return

  $("#{containerDiv} ul.media-list > li.media span.badge").click ->
    switch $(this).data('type')
      when 'history'
        $('div#sidebar ul > li#history').trigger('click')
        updateChart('div#historyDiv', {id: $(this).data('id')})
      when 'moveOut'
        detachPoint($(this)) if confirm("确认移出？")
      when 'delete'
        deleteTreeNode($(this)) if confirm("确认删除？")

    return

  return

deleteTreeNode = (node) ->
  $.ajax
    url: getBaseURL() + "/#{node.data('kind')}s/#{node.data('id')}.json"
    type: 'DELETE',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      # remove the <ul> elment
      node.parent().parent().parent().remove()
      $("div#routesDiv div#routeList ul#routeListGroup > li.list-group-item[data-id='#{node.data('id')}']").remove()
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout
  return

detachPoint = (point) ->
  routeNode = findParentRoute(point)
  $.ajax
    url: getBaseURL() + "/routes/#{routeNode.data('id')}/detach_point.json?point=#{point.data('id')}"
    type: 'PUT',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      # remove the <ul> elment
      point.parent().parent().parent().remove()
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout

  return

syncSamePointImg = (containerDiv, img, pic) ->
  id = img.data('id')
  for imgElem in $("#{containerDiv} ul.media-list > li.media > a.pull-left > img[data-id=#{id}]")
    imgElem = $(imgElem)
    src = imgElem.attr('src')
    switch pic
      when 'tool.png'
        imgElem.attr('src', src.replace(/tool.png/, 'care.png'))
      when 'care.png'
        imgElem.attr('src', src.replace(/care.png/, 'tool.png'))
  return

setupSessionsDiv = (containerDiv, defaultCalendarDaysRange, params) ->
  # Calendar widget
  setupCalendar(containerDiv, defaultCalendarDaysRange)

  # 更新button
  $("#{containerDiv} button#updateSessionsTableButton").click (e) ->
    updateSessionsTable(containerDiv, params)
    return
  return

setupRecordsDiv = (containerDiv, defaultCalendarDaysRange, params) ->
  # Calendar widget
  setupCalendar(containerDiv, defaultCalendarDaysRange)

  $("#{containerDiv} button#btnExportRecords").click ->
    requestParams = getTableParams(containerDiv)
    _url = getBaseURL() + '/results/export.json?' + ("#{k}=#{v}" for k, v of requestParams).join('&')
    window.open(_url)
    return

  # 更新button
  $("#{containerDiv} button#updateRecordsTableButton").click (e) ->
    updateRecordsTable(containerDiv, params)
    return

  # 重置button
  $("#{containerDiv} div#sessionFilterDiv button#btnResetRecordsHead").click ->
    $("#{containerDiv} div#sessionFilterDiv").hide()
    $("#{containerDiv} > div > div.calendarWidgetDiv").show()
    return

  return

updateSessionsTable = (containerDiv, params) ->
  requestParams = getTableParams(containerDiv, params)

  $.ajax
    url: getBaseURL() + '/sessions.json'
    beforeSend: (xhr) ->
      sessionsCalendarUpdated = $("#{containerDiv} > span#sessionsCalendarUpdated").text() is 'true'

      if sessionsCalendarUpdated
        # Force update since we changed calendar
        $("#{containerDiv} > span#sessionsCalendarUpdated").text('false')
        return

      setXhrRequestHeader(xhr, containerDiv, 'sessions')
      return
    data: requestParams
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for record in data
          columnDateToString(record, [2, 3])

        columns = [
          { "sTitle": "ID" },
          { "sTitle": "路线" },
          { "sTitle": "开始时间" },
          { "sTitle": "结束时间" },
          { "sTitle": "用户名" },
          { "sTitle": "邮箱" },
        ]

        if $("#{containerDiv} table#sessionsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#sessionsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#sessionsTable_wrapper").remove()
        $("#{containerDiv} > div").append('<table id="sessionsTable"></table>')
        $("#{containerDiv} table#sessionsTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 2, 'desc' ]]
          'fnRowCallback': (nRow, aaData, iDisplayIndex ) ->
            $(nRow).hover(
              ->
                $(this).addClass('mediumSeaGreenBackground')
                $(this).css('cursor', 'pointer')
                $("#{containerDiv} div#sessionsTooltipDiv").show()
                return
              ->
                $(this).removeClass('mediumSeaGreenBackground')
                $("#{containerDiv} div#sessionsTooltipDiv").hide()
                return
            )

            $(nRow).click ->
              showSessionInRecordsTable(aaData[0], aaData[1], aaData[2], aaData[3],
                getDatetimePickerEpoch('div#sessionsDiv div#startTime'),
                getDatetimePickerEpoch('div#sessionsDiv div#endTime'))
              return

            return

        oTable = $("#{containerDiv} table#sessionsTable").dataTable()
        oTable.fnSetColumnVis(0, false)

        $("#{containerDiv} > span#sessionsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#sessionsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

showSessionInRecordsTable = (sessionId, sessionRoute, sessionStartTime, sessionEndTime, searchStartTime, searchEndTime) ->
  $('div#recordsDiv > div > div.calendarWidgetDiv').hide()
  $('div#recordsDiv div#sessionFilterDiv').show()
  $('div#recordsDiv div#sessionFilterDiv > span:first-child').text(
    sessionRoute + '， ' + sessionStartTime + ' － ' + sessionEndTime)
  $('div#recordsDiv div#sessionFilterDiv > span:nth-child(2)').text(sessionId)
  $('div#recordsDiv div#startTime').data('datetimepicker').setLocalDate(
    new Date(searchStartTime * 1000))
  $('div#recordsDiv div#endTime').data('datetimepicker').setLocalDate(
    new Date(searchEndTime * 1000))
  $('div#sidebar li#records').trigger('click')
  return

updateRecordsTable = (containerDiv, params) ->
  requestParams = getTableParams(containerDiv, params)
  $sessionFilterDiv = $("#{containerDiv} div#sessionFilterDiv")
  if $sessionFilterDiv.length > 0 and $sessionFilterDiv.is(':visible')
    $.extend(requestParams, { check_session_id: $("#{containerDiv} div#sessionFilterDiv > span:nth-child(2)").text() })

  $.ajax
    url: getBaseURL() + '/results.json'
    beforeSend: (xhr) ->
      calendarUpdated = $("#{containerDiv} > span#calendarUpdated").text() is 'true'

      if calendarUpdated
        # Force update since we changed calendar
        $("#{containerDiv} > span#calendarUpdated").text('false')
        return

      setXhrRequestHeader(xhr, containerDiv, 'records')
      return
    data: requestParams
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        noMedia = true
        for record in data
          columnDateToString(record, [8])
          # record[9] is in form of [image_url, audio_url]
          if record[9][0] isnt null
            record[9][0] = "<a target='_blank' href='#{record[9][0]}'>图片</a>"

          if record[9][1] isnt null
            record[9][1] = "<a target='_blank' href='#{record[9][1]}'>音频</a>"

          if record[9][0] is null and record[9][1] is null
            record[9] = ''
          else
            noMedia = false
            record[9] = record[9].join('<br/>')

        columns = [
          { 'sTitle': '名称' },
          { 'sTitle': '描述' },
          {
            'sTitle': '机台信息',
            'sClass': 'center'
          },
          {
            'sTitle': '读数',
            'sClass': 'center'
          },
          {
            'sTitle': '正常范围',
            'sClass': 'center'
          },
          {
            'sTitle': '状态',
            'sClass': 'center'
          },
          { 'sTitle': '备注' },
          {
            'sTitle': '条形码',
            'sClass': 'center'
          },
          { 'sTitle': '检测时间' },
          {
            'sTitle': '媒体',
            'sClass': 'center',
            'sWidth': '46px'
          }
        ]
        if $("#{containerDiv} table#recordsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#recordsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#recordsTable_wrapper").remove()
        $("#{containerDiv} > div").append('<table id="recordsTable"></table>')
        $("#{containerDiv} table#recordsTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 8, 'desc' ]]
          'fnRowCallback': (nRow, aaData, iDisplayIndex ) ->
            switch aaData[5]
              when '异常'
                $(nRow).addClass('redBackground')
              when '警告'
                $(nRow).addClass('yellowBackground')
            return

        oTable = $("#{containerDiv} table#recordsTable").dataTable()
        oTable.fnSetColumnVis(9, false) if noMedia
        $("#{containerDiv} > span#recordsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#recordsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

setupHistoryDiv = (containerDiv) ->
  setupCalendar(containerDiv, 100)
  $("#{containerDiv} input#barcodeInput").val('')
  $("#{containerDiv} button#barcodeButton").click ->
    _val = $("#{containerDiv} input#barcodeInput").val()
    unless $.trim(_val)
      alert '条形码不能为空！'
      return

    updateChart(containerDiv, {barcode: _val})
    return

  $("#{containerDiv} button#btnPointSelection").click ->
    updatePointChart(containerDiv, {id: $("#{containerDiv} select#pointSelection").val()})
    return
  return

getCanvasOverlayObjects = (_point) ->
  canvasOverlayObjects = []
  _choice = JSON.parse(_point.choice)
  min = max = null
  unless _choice[0] is ''
    min = parseFloat(_choice[0])
    canvasOverlayObjects.push(
      dashedHorizontalLine:
        name: 'min'
        y: min
        lineWidth: 1,
        color: 'rgb(220, 20, 60)',
        shadow: false
    )

  unless _choice[1] is ''
    low = parseFloat(_choice[1])
    canvasOverlayObjects.push(
      dashedHorizontalLine:
        name: 'low'
        y: low
        lineWidth: 1,
        color: 'rgb(255, 255, 0)',
        shadow: false
    )

  unless _choice[2] is ''
    high = parseFloat(_choice[2])
    canvasOverlayObjects.push(
      dashedHorizontalLine:
        name: 'high'
        y: high
        lineWidth: 1,
        color: 'rgb(255, 255, 0)',
        shadow: false
    )

  unless _choice[3] is ''
    max = parseFloat(_choice[3])
    canvasOverlayObjects.push(
      dashedHorizontalLine:
        name: 'max'
        y: max
        lineWidth: 1,
        color: 'rgb(220, 20, 60)',
        shadow: false
    )

  [min, max, canvasOverlayObjects]

updateChart = (containerDiv, params) ->
  $("#{containerDiv} div#chartDiv").html('')
  $("#{containerDiv} div.historyBanner").hide()

  if params.barcode
    $.ajax
      url: getBaseURL() + "/assets/#{params.barcode}.json?barcode=true"
      success: (data, textStatus, jqHXR) ->
        if jqHXR.status is 200
          if data.points.length == 1
            updateChart(containerDiv, {id: data.points[0].id})
            return

          $("#{containerDiv} div#pointSelectionBanner").show()
          $pointSelection = $("#{containerDiv} div#pointSelectionBanner select#pointSelection")
          $pointSelection.html('')
          for point in data.points
            $pointSelection.append("<option value='#{point.id}'>#{point.name} #{point.description}</option>")

        return
      error: (jqXHR, textStatus, errorThrown) ->
        if jqXHR.status is 404
          updatePointChart(containerDiv, params)
        else
          showErrorPage(jqXHR.responseText)

        return
      dataType: 'json',
      timeout: defaultAjaxCallTimeout
  else
    updatePointChart(containerDiv, params)

  return

updatePointChart = (containerDiv, params) ->
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
    url: getBaseURL() + "/points/#{_id}/history.json?aggregate=30"
    data: request_params
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
         $('div#errorBanner, div#infoBanner').hide()
         _point = data.point
         $("#{containerDiv} input#barcodeInput").val(_point.barcode)
         if data.result.length is 0
           $('div#noHistoryBanner').text('该巡检点没有历史纪录').show()
         else
           $('div#noHistoryBanner').hide()
           title = "#{_point.name}   #{_point.description}"
           switch _point.category
             when 30, 50
               [min, max, canvasOverlayObjects] = getCanvasOverlayObjects(_point)

               if data.group
                 renderHighLowChart('chartDiv', title, data.result, min, max, canvasOverlayObjects)
               else
                 renderLineChart('chartDiv', title, data.result, min, max, canvasOverlayObjects)
             when 40,41
               renderBarChart('chartDiv', title, data.result, data.group, JSON.parse(_point.choice))
             when 10,30
               $('div#infoBanner').text("在选择时间范围内共巡检了#{data.result}次")
               $('div#infoBanner').show()
             else
               $('div#noHistoryBanner').text('该巡检点没有历史纪录').show()

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

renderHighLowChart = (chartId, title, data, _min, _max, canvasOverlayObjects) ->
  _ticks = [[0, ' ']]
  _hightlight_note = []
  _line = []
  _min = data[0].min.result if _min is null
  _max = data[0].max.result if _max is null

  for datum, i in data
    _min = datum.min.result if datum.min.result < _min
    _max = datum.max.result if datum.max.result > _max

  _min *= if _min > 0 then 0.95 else 1.05
  _max *= if _max > 0 then 1.05 else 0.95
  _height = (_max - _min) * 0.01

  for datum, i in data
    _range = dateRangeToString(new Date(datum.start_time * 1000), new Date(datum.end_time * 1000))
    _ticks.push([i+1, _range])
    if datum.max.result - datum.min.result < _height
      _min_factor = datum.min.result * (if datum.min.result > 0 then 0.99 else 1.01)
      _max_factor = datum.max.result * (if datum.max.result > 0 then 1.01 else 0.99)
      _max_factor = _min_factor + _height if _max_factor - _min_factor < _height
      _line.push([i+1, _max_factor, _min_factor])
    else
      _line.push([i+1, datum.max.result, datum.min.result])

    _hightlight_note.push("&nbsp;#{_range}<br/>
      &nbsp;#{datum.count}个巡检点<br/>
      &nbsp;最大值： #{datum.max.result}  （#{dateToString(new Date(datum.max.check_time * 1000))}）<br/>
      &nbsp;最小值： #{datum.min.result}   （#{dateToString(new Date(datum.min.check_time * 1000))}）")

  _ticks.push([data.length+1, ' '])
  _plot_setting =
    title: title
    axes:
      xaxis:
        ticks: _ticks,
        tickRenderer: $.jqplot.CanvasAxisTickRenderer,
        tickOptions:
          angle: chart_x_tick_angle
      yaxis:
        min: _min,
        max: _max,
        tickOptions:
          formatString: '%.0f'
    series: [{
      renderer:$.jqplot.OHLCRenderer,
      rendererOptions:
        lineWidth: 5
    }]
    highlighter:
      tooltipContentEditor: (str, seriesIndex, pointIndex) ->
        _hightlight_note[pointIndex]
      show: true,
      showMarker: false,
      tooltipLocation: 'se',
      formatString:'%s'
    canvasOverlay:
      show: true,
      objects: canvasOverlayObjects

  $.jqplot(
    chartId,
    [_line],
    _plot_setting
  )

  return

renderLineChart = (chartId, title, data, _min, _max, canvasOverlayObjects) ->
  _ticks = [[0, ' ']]
  _hightlight_note = []
  _line = []
  _min = data[0].min.result if _min is null
  _max = data[0].min.result if _max is null

  for datum, i in data
    _range = dateToString(new Date(datum.start_time * 1000))
    value = datum.min.result
    _min = value if value < _min
    _max = value if value > _max
    _ticks.push([i+1, _range])
    _line.push([i+1, value])
    _hightlight_note.push("&nbsp;数值： #{value}   （#{dateToString(new Date(datum.min.check_time * 1000))}）")

  _ticks.push([data.length+1, ' '])
  _min *= if _min > 0 then 0.98 else 1.02
  _max *= if _max > 0 then 1.02 else 0.98
  _plot_setting =
    title: title
    axes:
      xaxis:
        ticks: _ticks,
        tickRenderer: $.jqplot.CanvasAxisTickRenderer,
        tickOptions:
          angle: chart_x_tick_angle
      yaxis:
        min: _min,
        max: _max,
        tickOptions:
          formatString: '%.0f'
    series: [{
      rendererOptions:
        lineWidth: 2,
        markerOptions: { style:'circle' }
    }]
    highlighter:
      tooltipContentEditor: (str, seriesIndex, pointIndex) ->
        _hightlight_note[pointIndex]
      show: true,
      showMarker: false,
      tooltipLocation: 'se'
    canvasOverlay:
      show: true,
      objects: canvasOverlayObjects

  $.jqplot(
    chartId,
    [_line],
    _plot_setting
  )

  return

renderBarChart = (chartId, title, data, group, choice) ->
  _line = []
  _line.push(new Array()) for [1..choice.length]

  _ticks = []
  for datum, i in data
    if group
      _range = dateRangeToString(new Date(datum.start_time * 1000), new Date(datum.end_time * 1000))
    else
      _range = dateToString(new Date(datum.start_time * 1000))

    _ticks.push(_range)
    for select, i in datum.selection
      _line[i].push(select)

  _series = ({label: c} for c in choice)
  _plot_setting =
    title: title
    stackSeries: true
    captureRightClick: true
    seriesDefaults:
      renderer: $.jqplot.BarRenderer
      rendererOptions:
        barMargin: 8
      pointLabels:
        show: true
        hideZeros: true
    series: _series
#    seriesColors: ['rgb(220, 20, 60)', 'rgb(220, 30, 60)', 'rgb(20, 20, 60)', 'rgb(220, 20, 20)']
    axesDefaults:
      tickRenderer: $.jqplot.CanvasAxisTickRenderer
    axes:
      xaxis:
        renderer: $.jqplot.CategoryAxisRenderer
        ticks: _ticks
        tickOptions:
          angle: chart_x_tick_angle
      yaxis:
        padMin: 0
        min: 0
        tickOptions: {formatString: '%d'}
    legend:
      show: true,
      location: 'ne',
      placement: 'outside'

  $.jqplot(
    chartId,
    _line,
    _plot_setting
  )
  return

confirmExit = ->
  if $('div#routes > span#preferencesUpdated').text() is 'true'
    '您在“我的路线”页面有更新但未点击“更新我的关注”按钮，还要继续离开本页吗？'


###
  Admin tabs
###

setupCreatePointForm = (containerDiv) ->
  _suggestions = []
  setupAutocompleteInput('/users.json', 'name', containerDiv,
    'input#point_assigned_to',
    _suggestions, $("#{containerDiv} span#point_assigned_to_id"))

  $('div#createPoint button#btnCreatePoint').unbind('click')
  $('div#createPoint button#btnCreatePoint').click ->
    requestType = null
    _relativeUrl = null
    switch $('div#createPoint > h2:first').text()
      when '创建检点'
        requestType = 'POST'
        _relativeUrl = '/points.json'
      when '编辑检点'
        requestType = 'PUT'
        _relativeUrl = "/points/#{$('div#createPoint span#pointId').text()}.json"
      else
        alert "Wrong createPoint title #{$('div#createPoint > h2:first').text()}"
        return

    pointInfo = {}
    return unless validateCreatePointForm('div#createPoint', pointInfo, _suggestions)
    pointInfo['choice'] = JSON.stringify(pointInfo['choice']) if requestType is 'POST'
    $pointDescription = $('div#createPoint input#pointDescription')
    pointInfo['description'] = $pointDescription.val() unless isInputValueEmpty($pointDescription)
    $pointBarcode = $('div#createPoint input#pointBarcode')
    pointInfo['barcode'] = $pointBarcode.val() unless isInputValueEmpty($pointBarcode)

    $.ajax
      url: getBaseURL() + _relativeUrl
      type: requestType,
      contentType: 'application/json',
      data: JSON.stringify(pointInfo),
      dataType: 'json',
      success: (data, textStatus, jqHXR) ->
        clearCreatePointForm()
        _switchPointTo = $('div#managementData span#switchPointTo').text()
        unless _switchPointTo is ''
          $('div#managementData span#switchPointTo').text('')
          $("#{_switchPointTo}").show()
          $('div#createPoint').hide()
          switch requestType
            when 'POST'
              $('div#addedPointDiv').append("<span class='lavenderBackground'>
                                        <span class='hiddenSpan'>#{data.id}</span>#{data.name}</span>")
              alert '检点创建成功'
            when 'PUT'
              alert '检点编辑成功'
              updatePointsTable('div#managementData div#editDeletePoint')
        return
      error: (jqXHR, textStatus, errorThrown) ->
        alert jqXHR.responseJSON.message
        return
      timeout: defaultAjaxCallTimeout
  return

setupManageDataDiv = ->
  $('div#managementButtons ul.dropdown-menu > li > a').click ->
    $('div#managementData > div').hide()
    divId = $(this).data('div')
    $("div#managementData > div##{divId}").show()
    switch divId
      when 'createRoute'
        $('div#createRoute button#btnCancelCreateRoute').text('重置')
        $('div#createRoute > h2:first').text('创建路线')
        $('div#createRoute').show()
        setupAddContactToRouteBtn('div#createRoute')
        clearCreateRouteForm()
      when 'editDeleteRoute'
        $('div#createRoute button#btnCancelCreateRoute').text('返回')
        $('div#createRoute > h2:first').text('编辑路线')
        $('div#editDeleteRoute > div').show()
        updateRoutesTable('div#managementData div#editDeleteRoute')
      when 'createPoint'
        $('div#managementData span#switchPointTo').text('')
        $('div#createPoint button#btnCancelCreatePoint').text('重置')
        $('div#createPoint > h2:first').text('创建检点')
        $('div#managementData div#categorySelection').show()
        setupCreatePointForm('div#createPoint')
      when 'createAsset'
        $('div#createPoint button#btnCancelCreatePoint').text('重置')
        $('div#createPoint > h2:first').text('创建检点')
        $('div#managementData div#categorySelection').show()
      when 'editDeletePoint'
        $('div#managementData div#pointsTableDiv, div#managementData div#edit_delete_point_buttons').show()
        $('div#createPoint').hide()
        $('div#createPoint button#btnCancelCreatePoint').text('返回')
        $('div#createPoint > h2:first').text('编辑检点')
        $('div#managementData div#categorySelection').hide()
        updatePointsTable('div#managementData div#editDeletePoint')
      when 'deleteAsset'
        updateAssetsTable('div#managementData div#deleteAsset')
      when 'attachPointToAsset'
        updateAssetsTable('div#managementData div#attachPointToAsset')
        updatePointsTable('div#managementData div#attachPointToAsset')
      when 'attachPointToRoute'
        updateRoutesTable('div#managementData div#attachPointToRoute')
        updatePointsTable('div#managementData div#attachPointToRoute')
    return

  $('form#uploadFile').fileupload
    url: getBaseURL() + '/file.json',
    dataType: 'json',
    done: (e, data)->
      console.log "Done", data.result
      $('div#uploadInfo').addClass('alert-success').text('上传成功！').show()
      return

  setupCreatePointDiv()
  setupEditDeleteRouteDiv('div#managementData div#editDeleteRoute')
  setupEditDeletePointDiv('div#managementData div#editDeletePoint')
  setupCreateAssetDiv()
  setupDeleteAssetDiv('div#managementData div#deleteAsset')
  setupCreateRouteDiv()
  setupAttachPointToAssetDiv('div#managementData div#attachPointToAsset')
  setupAttachPointToRouteDiv('div#managementData div#attachPointToRoute')

  return

setupAttachPointToRouteDiv = (containerDiv) ->
  $("#{containerDiv} button#btnAttachPointToRoute").click ->
    oTable1 = $("#{containerDiv} table#routesTable").dataTable()
    _selectedTr1 = oTable1.$('tr.mediumSeaGreenBackground')
    if _selectedTr1.length is 0
      alert '请选择路线！'
      return

    oTable2 = $("#{containerDiv} table#pointsTable").dataTable()
    _selectedTr2 = oTable2.$('tr.mediumSeaGreenBackground')
    if _selectedTr2.length is 0
      alert '请选择检点！'
      return

    row1 = oTable1.fnGetData(_selectedTr1[0])
    row2 = oTable2.fnGetData(_selectedTr2[0])
    attachPointToRoute(row2[0], row1[0], containerDiv) if confirm("连接检点 '#{row2[1]}' 条形码 '#{row2[2]}' 到路线 '#{row1[1]}' 吗？")

    return

  return

attachPointToRoute = (pointId, routeId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/routes/#{routeId}/attach_point?point=#{pointId}"
    type: 'PUT',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updateRoutesTable(containerDiv)
      updatePointsTable(containerDiv)
      alert '已经成功连接检点到设备！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout
  return

updateRoutesTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/routes.json?show_name=true'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'routes')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        records = ([record['id'], record['name'], record['description'], record['area_name'], record['points'], joinStringArrayWithBR(record['contacts'])] for record in data)

        columns = [
          { "sTitle": "ID" },
          { "sTitle": "名称" },
          { "sTitle": "描述" },
          { "sTitle": "工区" },
          { "sTitle": "检点" },
          { "sTitle": "联系人" }
        ]
        if $("#{containerDiv} table#routesTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#routesTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#routesTable_wrapper").remove()
        $("#{containerDiv} div#routesTableDiv").append('<table id="routesTable"></table>')
        $("#{containerDiv} table#routesTable").dataTable
          'aaData': records
          'aoColumns': columns
          'aaSorting': [[ 1, 'desc' ]]
          'iDisplayLength': 5
          'aLengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, '全部']]

        oTable = $("#{containerDiv} table#routesTable").dataTable()
        oTable.fnSetColumnVis(0, false)
        $("#{containerDiv} table#routesTable > tbody").on(
          'click',
          'tr',
          ->
            oTable = $("#{containerDiv} table#routesTable").dataTable()
            oTable.$('tr.mediumSeaGreenBackground').removeClass('mediumSeaGreenBackground')
            $(this).addClass('mediumSeaGreenBackground')
            return
        )

        $("#{containerDiv} span#routesIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} span#routesIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
        return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout
  return

setupAttachPointToAssetDiv = (containerDiv) ->
  $("#{containerDiv} button#btnAttachPointToAsset").click ->
    oTable1 = $("#{containerDiv} table#assetsTable").dataTable()
    _selectedTr1 = oTable1.$('tr.mediumSeaGreenBackground')
    if _selectedTr1.length is 0
      alert '请选择设备！'
      return

    oTable2 = $("#{containerDiv} table#pointsTable").dataTable()
    _selectedTr2 = oTable2.$('tr.mediumSeaGreenBackground')
    if _selectedTr2.length is 0
      alert '请选择检点！'
      return

    row1 = oTable1.fnGetData(_selectedTr1[0])
    row2 = oTable2.fnGetData(_selectedTr2[0])
    attachPointToAsset(row2[0], row1[0], containerDiv) if confirm("连接检点 '#{row2[1]}' 条形码 '#{row2[2]}' 到设备 '#{row1[1]}' 条形码 '#{row1[2]}' 吗？")

    return

  return

attachPointToAsset = (pointId, assetId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/assets/#{assetId}/attach_point?point=#{pointId}"
    type: 'PUT',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updateAssetsTable(containerDiv)
      updatePointsTable(containerDiv)
      alert '已经成功连接检点到设备！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout
  return

setupDeleteAssetDiv = (containerDiv) ->
  $("#{containerDiv} button#btnDeleteAsset").click ->
    oTable = $("#{containerDiv} table#assetsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择设备！'
    else
      row = oTable.fnGetData(_selectedTr[0])
      deleteAsset(row[0], containerDiv) if confirm("您确定要删除设备 '#{row[1]}' 条形码 '#{row[2]}' 吗？")

    return

  return

deleteAsset = (assetId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/assets/#{assetId}.json"
    type: 'DELETE',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updateAssetsTable(containerDiv)
      alert '设备已经成功删除！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout

  return

updateAssetsTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/assets.json?ui=true'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'assets')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for record in data
          record[3] = joinStringArrayWithBR(record[3])

        columns = [
          { "sTitle": "ID" },
          { "sTitle": "名称" },
          { "sTitle": "条形码" },
          { "sTitle": "检点" }
        ]
        if $("#{containerDiv} table#assetsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#assetsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#assetsTable_wrapper").remove()
        $("#{containerDiv} div#assetsTableDiv").append('<table id="assetsTable"></table>')
        $("#{containerDiv} table#assetsTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 1, 'desc' ]]
          'iDisplayLength': 5
          'aLengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, '全部']]

        oTable = $("#{containerDiv} table#assetsTable").dataTable()
        oTable.fnSetColumnVis(0, false)
        $("#{containerDiv} table#assetsTable > tbody").on(
          'click',
          'tr',
          ->
            oTable = $("#{containerDiv} table#assetsTable").dataTable()
            oTable.$('tr.mediumSeaGreenBackground').removeClass('mediumSeaGreenBackground')
            $(this).addClass('mediumSeaGreenBackground')
            return
        )

        $("#{containerDiv} span#assetsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} span#assetsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout
  return

setupEditDeletePointDiv = (containerDiv) ->
  $("#{containerDiv} button#btnEditPoint").click ->
    oTable = $("#{containerDiv} table#pointsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择检点！'
    else
      row = oTable.fnGetData(_selectedTr[0])

      _switchPointTo = "#{containerDiv} div#pointsTableDiv, #{containerDiv} div#edit_delete_point_buttons"
      $('div#managementData span#switchPointTo').text(_switchPointTo)
      $(_switchPointTo).hide()
      $('div#createPoint').show()
      setupCreatePointForm('div#createPoint')
      $.ajax
        url: getBaseURL() + "/points/#{row[0]}.json?r=#{getRandomArbitrary(0, 10240)}" # disable browser cache for the same GET
        success: (data, textStatus, jqHXR) ->
          if jqHXR.status is 200
            $('div#createPoint span#pointId').text(data.id)
            $('div#createPoint input#pointName').val(data.name)
            $('div#createPoint input#pointDescription').val(data.description)
            $('div#createPoint input#pointBarcode').val(data.barcode)
            if data.default_assigned_id
              $('div#createPoint input#point_assigned_to').val(data.default_assigned_user)
              $('div#createPoint span#point_assigned_to_id').text(data.default_assigned_id)

          return
        error: (jqXHR, textStatus, errorThrown) ->
          showErrorPage(jqXHR.responseText)
          return
        ifModified: true,
        dataType: 'json',
        timeout: defaultAjaxCallTimeout

    return

  $("#{containerDiv} button#btnDeletePoint").click ->
    oTable = $("#{containerDiv} table#pointsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择检点！'
    else
      row = oTable.fnGetData(_selectedTr[0])
      deletePoint(row[0], containerDiv) if confirm("您确定要删除检点 '#{row[1]}' 条形码 '#{row[2]}' 吗？")

    return

  return

deletePoint = (pointId, containerDiv) ->
  $.ajax
    url: getBaseURL() + "/points/#{pointId}.json"
    type: 'DELETE',
    contentType: 'application/json',
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      updatePointsTable(containerDiv)
      alert '检点已经成功删除！'
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout
  return

updatePointsTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/points.json?ui=true'
    beforeSend: (xhr) ->
      setXhrRequestHeader(xhr, containerDiv, 'points')
      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for record in data
          record[4] = joinStringArrayWithBR(record[4])
          record[6] = joinStringArrayWithBR(record[6])

        columns = [
          { "sTitle": "ID" },
          { "sTitle": "名称" },
          { "sTitle": "条形码" },
          {
            "sTitle": "类型",
            "sClass": "center",
            "sWidth": "45px"
          },
          {
            "sTitle": "选项",
            "sWidth": "20%"
          },
          { "sTitle": "设备" },
          { "sTitle": "路线" },
          {
            "sTitle": "责任人",
            "sClass": "center"
          }
        ]
        if $("#{containerDiv} table#pointsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#pointsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#pointsTable_wrapper").remove()
        $("#{containerDiv} div#pointsTableDiv").append('<table id="pointsTable"></table>')
        $("#{containerDiv} table#pointsTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 5, 'desc' ]]
          'iDisplayLength': 5
          'aLengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, '全部']]
          'fnRowCallback': (nRow, aaData, iDisplayIndex ) ->
            switch aaData[3]
              when '日常巡检'
                $(nRow).addClass('darkBlueTextColor')
              when '普通巡检'
                $(nRow).addClass('darkGreenTextColor')
              when '状态'
                $(nRow).addClass('darkCyanTextColor')
            return

        oTable = $("#{containerDiv} table#pointsTable").dataTable()
        oTable.fnSetColumnVis(0, false)
        $("#{containerDiv} table#pointsTable > tbody").on(
          'click',
          'tr',
          ->
            oTable = $("#{containerDiv} table#pointsTable").dataTable()
            oTable.$('tr.mediumSeaGreenBackground').removeClass('mediumSeaGreenBackground')
            $(this).addClass('mediumSeaGreenBackground')
            return
        )

        $("#{containerDiv} span#pointsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} span#pointsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout
  return

setupAddContactToRouteBtn = (containerDiv) ->
  _suggestions = []
  setupAutocompleteInput('/contacts.json', ['name', 'email'], containerDiv, 'input#contact_add_to_route',
    _suggestions, $("#{containerDiv} span#contact_add_to_route_id"))

  $("#{containerDiv} span#addContactToRouteSpan").unbind('click')
  $("#{containerDiv} span#addContactToRouteSpan").click ->
    _contact = $("#{containerDiv} input#contact_add_to_route").val().trim()
    _contactId = $("#{containerDiv} span#contact_add_to_route_id").text()
    if _contact is ''
      $("#{containerDiv} span#contact_add_to_route_id").text('')
      alert '请填写联系人！'
      return

    _c = $.grep(
      _suggestions,
      (e) ->
        e.data.toString() is _contactId
    )

    unless _c.length > 0 and _c[0].value is _contact
      alert '联系人填写错误！'
      return

    $("#{containerDiv} div#contacts_for_route").append("<span class='lavenderBackground'>
       <span class='hiddenSpan'>#{_contactId}</span><i class='icon-remove'></i>#{_contact}</span>")
    $("#{containerDiv} div#contacts_for_route > span > i").click(removeParent)
    return

  return

setupCreateRouteDiv = ->
  $('div#createRoute button#btnCancelCreateRoute').click ->
    clearCreateRouteForm()
    if $('div#createRoute > h2:first').text() is '编辑路线'
      $('div#editDeleteRoute > div').show()
      $('div#createRoute').hide()

    return

  $('div#createRoute button#btnCreateRoute').click ->
    $routeName = $('div#createRoute input#routeName')
    if isInputValueEmpty($routeName)
      alert '请填写名称！'
      return

    routeInfo = {}
    routeInfo['name'] = $routeName.val()
    $routeDescription = $('div#createRoute input#routeDescription')
    routeInfo['description'] = $routeDescription.val() unless isInputValueEmpty($routeDescription)
    routeInfo['area'] = $('div#createRoute select#routeArea').val()
    _contacts = []
    routeInfo['contacts'] = []

    for span in $('div#createRoute div#contacts_for_route > span')
      _contact = $.trim($(span).text())
      if _contact in _contacts
        alert "您有重复的联系人： #{_contact}"
        return

      _contacts.push(_contact)
      routeInfo['contacts'].push($(span).children('span').text()) # contact id

    requestType = null
    _relativeUrl = null
    switch $('div#createRoute > h2:first').text()
      when '创建路线'
        requestType = 'POST'
        _relativeUrl = '/routes.json'
      when '编辑路线'
        requestType = 'PUT'
        _relativeUrl = "/routes/#{$('div#createRoute span#routeId').text()}.json"
      else
        alert "Wrong createRoute title #{$('div#createRoute > h2:first').text()}"
        return

    $.ajax
      url: getBaseURL() + _relativeUrl
      type: requestType,
      contentType: 'application/json',
      data: JSON.stringify(routeInfo),
      dataType: 'json',
      success: (data, textStatus, jqHXR) ->
        clearCreateRouteForm()
        switch requestType
          when 'POST'
            alert '路线创建成功'
          when 'PUT'
            $('div#createRoute').hide()
            $('div#editDeleteRoute > div').show()
            updateRoutesTable('div#managementData div#editDeleteRoute')
            alert '路线编辑成功'

        return
      error: (jqXHR, textStatus, errorThrown) ->
        alert jqXHR.responseJSON.message
        return
      timeout: defaultAjaxCallTimeout
    return

  return

clearCreateRouteForm = ->
  resetToPlaceholderValue($('div#createRoute input'))
  $('div#createRoute select#routeArea').val(1) # set to select first item
  $('div#createRoute span#routeId').text('')
  $('div#createRoute div#contacts_for_route').html('')
  $('div#createRoute input#contact_add_to_route').val('')
  $('div#createRoute span#contact_add_to_route_id').text('')
  return

setupCreateAssetDiv = ->
  $('div#createAsset button#btnAddPointToAsset').click ->
    $('div#managementData span#switchPointTo').text('div#createAsset')
    clearCreatePointForm()
    $('div#createAsset').hide()
    $('div#createPoint').show()
    setupCreatePointForm('div#createPoint')
    return

  $('div#createAsset button#btnCancelCreateAsset').click(clearCreateAssetForm)

  $('div#createAsset button#btnCreateAsset').click ->
    $assetName = $('div#createAsset input#assetName')
    if isInputValueEmpty($assetName)
      alert '请填写名称！'
      return

    assetInfo = {}
    assetInfo['name'] = $assetName.val()

    $assetDescription = $('div#createAsset input#assetDescription')
    assetInfo['description'] = $assetDescription.val() unless isInputValueEmpty($assetDescription)
    $assetBarcode = $('div#createAsset input#assetBarcode')
    assetInfo['barcode'] = $assetBarcode.val() unless isInputValueEmpty($assetBarcode)

    pointIds = (parseInt($(pointId).text()) for pointId in $('div#createAsset div#addedPointDiv > span > span'))
    assetInfo['points'] = pointIds
    $.ajax
      url: getBaseURL() + '/assets.json'
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(assetInfo),
      dataType: 'json',
      success: (data, textStatus, jqHXR) ->
        alert '设备创建成功'
        clearCreateAssetForm()
        return
      error: (jqXHR, textStatus, errorThrown) ->
        alert jqXHR.responseJSON.message
        return
      timeout: defaultAjaxCallTimeout
    return

  return

clearCreateAssetForm = ->
  resetToPlaceholderValue($('div#createAsset input'))
  $('div#createAsset div#addedPointDiv > span').remove()
  return

setupCreatePointDiv = ->
  $('div#categorySelection select#pointCategory').change ->
    switch $(this).val()
      when '40','41'
        $('div#addPointChoiceDiv').show()
        $('div#fourChoicesDiv').hide()
      when '50'
        $('div#addPointChoiceDiv').hide()
        $('div#fourChoicesDiv').show()
      else
        $('div#addPointChoiceDiv, div#fourChoicesDiv').hide()
    return

  $('div#addChoiceButtonDiv button#addChoiceButton').click ->
    input = $('div#pointChoiceDiv > input').val()
    if input is '填写选项'
      alert '请填写选项！'
      return

    $('div#pointChoiceDiv > div:first').append("<span class='lavenderBackground'>
        <i class='icon-remove'></i>#{input}</span>")
    $('div#pointChoiceDiv > div:first > span:last > i').click(removeParent)
    return

  $('div#pointChoiceDiv > div:first > span > i').click(removeParent)

  $('div#createPoint button#btnCancelCreatePoint').click ->
    clearCreatePointForm()
    _switchPointTo = $('div#managementData span#switchPointTo').text()
    unless _switchPointTo is ''
      $('div#managementData span#switchPointTo').text('')
      $("#{_switchPointTo}").show()
      $('div#createPoint').hide()
      switch $('div#createPoint > h2:first').text()
        when '编辑检点'
          updatePointsTable('div#managementData div#editDeletePoint')
      return

    return

  $('div#categorySelection select#pointCategory').val(10) # set to select first item
  return

validateCreatePointForm = (containerDiv, pointInfo, suggestions) ->
  pointInfo = {} unless pointInfo
  pointName = $("#{containerDiv} input#pointName")
  if isInputValueEmpty(pointName)
    alert '请填写名称！'
    return false

  pointInfo['name'] = pointName.val()
  pointCategory = $("#{containerDiv} div#categorySelection select#pointCategory").val()
  pointInfo['category'] = pointCategory
  pointInfo['choice'] = []
  switch pointCategory
    when '40','41'
      for span in $("#{containerDiv} div#pointChoiceDiv > div:first > span")
        choice = $.trim($(span).text())
        if choice in pointInfo['choice']
          alert "您有重复的选项： #{choice}"
          return false

        pointInfo['choice'].push(choice)
    when '50'
      nums = []
      for num in ['Min', 'Low', 'High', 'Max']
        $inputNumber = $("#{containerDiv} input#point#{num}")
        if isInputValueEmpty($inputNumber)
          pointInfo['choice'].push(null)
          continue
        inputNumber = $inputNumber.val()
        pointInfo['choice'].push(inputNumber)
        if inputNumber
          n = parseFloat(inputNumber)
          if isNaN(n)
            alert "#{inputNumber} 不是数字！"
            return false
          nums.push parseFloat(n)

      for num, i in nums
        if i != 0 and num < nums[i-1]
          alert "数字 '#{nums}' 不符合逻辑。应该递增排列！"
          return false

  assignedUser = $("#{containerDiv} input#point_assigned_to").val().trim()
  assignedToId = $("#{containerDiv} span#point_assigned_to_id").text()
  valid = true

  if assignedUser is ''
    $("#{containerDiv} span#point_assigned_to_id").text('')
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

  pointInfo['default_assigned_id'] = assignedToId
  true

clearCreatePointForm = ->
  $('div#categorySelection select#pointCategory').val(10) # set to select first item
  $('div#addPointChoiceDiv, div#fourChoicesDiv').hide()
  resetToPlaceholderValue($('div#createPoint input'))
  $('div#pointChoiceDiv > div:first > span').remove()
  $('div#pointChoiceDiv > div:first').append("<span class='lavenderBackground'>
          <i class='icon-remove'></i>正常</span>")
  $('div#pointChoiceDiv > div:first').append("<span class='lavenderBackground'>
            <i class='icon-remove'></i>非正常</span>")
  $('div#pointChoiceDiv > div:first > span > i').click(removeParent)
  $('div#assignedToSelection input#point_assigned_to').val('')
  $('div#assignedToSelection span#point_assigned_to_id').text('')
  return

setupEditDeleteRouteDiv = (containerDiv) ->
  $("#{containerDiv} button#btnEditRoute").click ->
    oTable = $("#{containerDiv} table#routesTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择路线！'
    else
      row = oTable.fnGetData(_selectedTr[0])
      $("#{containerDiv} > div").hide()
      $('div#createRoute').show()
      clearCreateRouteForm()
      setupAddContactToRouteBtn('div#createRoute')
      $.ajax
        url: getBaseURL() + "/routes/#{row[0]}.json?r=#{getRandomArbitrary(0, 10240)}" # disable browser cache for the same GET
        success: (data, textStatus, jqHXR) ->
          if jqHXR.status is 200
            $('div#createRoute span#routeId').text(data.id)
            $('div#createRoute input#routeName').val(data.name)
            $('div#createRoute input#routeDescription').val(data.description)
            changeSelectByValue('routeArea', data.area_id)
            if data.contacts
              for c in data.contacts
                $('div#createRoute div#contacts_for_route').append("<span class='lavenderBackground'>
                       <span class='hiddenSpan'>#{c.id}</span><i class='icon-remove'></i>#{c.name} #{c.email}</span>")

              $('div#createRoute div#contacts_for_route > span > i').click(removeParent)

    return
  error: (jqXHR, textStatus, errorThrown) ->
    showErrorPage(jqXHR.responseText)
    return
  ifModified: true,
  dataType: 'json',
  timeout: defaultAjaxCallTimeout

  $("#{containerDiv} button#btnDeleteRoute").click ->
    oTable = $("#{containerDiv} table#routesTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择路线！'
    else
      row = oTable.fnGetData(_selectedTr[0])
      if confirm("您确定要删除路线 '#{row[1]}' 吗？")
        $.ajax
          url: getBaseURL() + "/routes/#{row[0]}.json"
          type: 'DELETE',
          contentType: 'application/json',
          dataType: 'json',
          success: (data, textStatus, jqHXR) ->
            updateRoutesTable(containerDiv)
            alert '路线已经成功删除！'
            return
          error: (jqXHR, textStatus, errorThrown) ->
            alert jqXHR.responseJSON.message
            return
          timeout: defaultAjaxCallTimeout

    return

  return