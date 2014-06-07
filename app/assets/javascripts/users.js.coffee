chart_x_tick_angle = 45
fade_speed = 400

$ ->
  return unless isUserPage()
  setupSidebar()
  $('div.containerDiv').first().show()
  setupRecordsDiv('div#preferencesDiv', 1, { preference: true })
  updateRecordsTable('div#preferencesDiv', { preference: true })
  setupRoutesDiv('div#routes')
  setupFactoriesDiv('div#factories')
  setupRecordsDiv('div#recordsDiv', 1)
  setupHistoryDiv('div#historyDiv')

  # Check on exiting page
  window.onbeforeunload = confirmExit
  removeFlashNotice()

  # Admn tabs
  return unless getPageTitle() is '巡检 | 管理员'

  setupManageUsersDiv('div#manageUsersDiv')
  setupManageDataDiv()
  return

isUserPage = ->
  _pageTitle = getPageTitle()
  return true if _pageTitle in ['巡检 | 用户', '巡检 | 管理员', '巡检 | 高级用户']
  return false

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
      when 'records'
        updateRecordsTable(containerDiv)
      when 'manageUsers'
        updateUsersTable(containerDiv)
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
  renderTreeView('/factories.json', "#{containerDiv} div#factoriesTree", "#{containerDiv} span#factories")
  $('div#routesDiv div#routeListInFactory ul.list-group > li').hide()
  $('div#routesDiv div#routeListInFactory h3.panel-title').text('路线')
  return

updateRouteList = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/routes.json'
    beforeSend: (xhr) ->
      routesIfNoneMatch = $("#{containerDiv} > span#routesIfNoneMatch").text()
      routesIfModifiedSince = $("#{containerDiv} > span#routesIfModifiedSince").text()

      if routesIfNoneMatch isnt '' and routesIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', routesIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', routesIfModifiedSince)

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

        renderTreeView('/routes.json', "#{containerDiv} div#routesTree", null, {group_by_asset: true}, true)
      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified:true,
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

setupTreeViewControlButtons = (containerDiv) ->
  $("#{containerDiv} button#collapseTree").click ->
    $("#{containerDiv} ul.media-list > li.media > a.pull-left > img[src$='minus.png']").trigger('click')
    return
  $("#{containerDiv} button#openTree").click ->
    $("#{containerDiv} ul.media-list > li.media > a.pull-left > img[src$='plus.png']").trigger('click')
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

renderTreeView = (url, containerDiv, ifModifiedSinceSpanId, params, hideTree) ->
  request_params = { ui: true }
  $.extend(request_params, params) if params # merge two objects
  $.ajax
    url: getBaseURL() + url
    data: request_params
    beforeSend: (xhr) ->
      return if ifModifiedSinceSpanId is null
      ifNoneMatch = $("#{ifModifiedSinceSpanId}IfNoneMatch").text()
      ifModifiedSince = $("#{ifModifiedSinceSpanId}routesIfModifiedSince").text()

      if ifNoneMatch isnt '' and ifModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', ifNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', ifModifiedSince)

      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $(containerDiv).html('')
        buildTreeNode($(containerDiv), data)
        bindTreeViewClick(containerDiv)

        $("#{containerDiv} > ul").hide() if hideTree is true
        unless ifModifiedSinceSpanId is null
          $("#{ifModifiedSinceSpanId}IfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
          $("#{ifModifiedSinceSpanId}IfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified:true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

buildTreeNode = (parent, data) ->
  for nodeDatum, i in data
    historyIcon = ''
    historyIcon = "<span class='badge' data-id='#{nodeDatum.id}'>历史</span>" if nodeDatum.kind is 'point'
    parent.append "
    <ul class='media-list' data-id='#{nodeDatum.id}'>
      <li class='media'>
        <a class='pull-left'>
          <img src='/assets/#{nodeDatum.icon}' class='media-object mediaListIcon' data-id='#{nodeDatum.id}'/>
        </a>
        <div class='media-body'>
        <h4 class='media-heading'>#{nodeDatum.title}#{historyIcon}</h4>
        <span>#{nodeDatum.description}</span>"

    $ul = $(parent.children('ul')[i])
    buildTreeNode($ul.find('li > div.media-body'), nodeDatum.children)
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
        $("div#routesDiv ul#routeListGroupInFactory > li.list-group-item[data-group='#{id}']").show()
        $('div#routesDiv div#routeListInFactory h3.panel-title').text($(this).next().children('span').text())

    $(this).next('div.media-body').children('ul.media-list').toggle()

    return

  $("#{containerDiv} ul.media-list > li.media span.badge").click ->
    $('div#sidebar ul > li#history').trigger('click')
    updateChart('div#historyDiv', {id: $(this).data('id')})
    return

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

setupRecordsDiv = (containerDiv, defaultCalendarDaysRange, params) ->
  # Calendar widget
  setupCalendar(containerDiv, defaultCalendarDaysRange)

  # 更新button
  $("#{containerDiv} button#updateRecordsTableButton").click (e) ->
    updateRecordsTable(containerDiv, params)
    return
  return

setupCalendar = (containerDiv, defaultCalendarDaysRange) ->
  $("#{containerDiv} div#startTime").datetimepicker(getDatetimePickerSettings())
  $("#{containerDiv} div#endTime").datetimepicker(getDatetimePickerSettings())
  startTimePicker = $("#{containerDiv} div#startTime").data('datetimepicker')
  endTimePicker = $("#{containerDiv} div#endTime").data('datetimepicker')
  $("#{containerDiv} div#startTime").on 'changeDate', (e) ->
    start_time = e.localDate.getTime()/1000
    end_time = getDatetimePickerEpoch("#{containerDiv} div#endTime")
    endTimePicker.setLocalDate(new Date(start_time * 1000)) if start_time > end_time
    return
  $("#{containerDiv} div#endTime").on 'changeDate', (e) ->
    end_time = e.localDate.getTime()/1000
    start_time = getDatetimePickerEpoch("#{containerDiv} div#startTime")
    startTimePicker.setLocalDate(new Date(end_time * 1000)) if start_time > end_time
    return

  today = getToday()
  endTimePicker.setLocalDate(today)
  startTimePicker.setLocalDate(today.addDays(-defaultCalendarDaysRange))
  $("#{containerDiv} div#startTime > span.add-on, #{containerDiv} div#endTime > span.add-on, #{containerDiv} div#startTime, #{containerDiv} div#endTime").click ->
    $("#{containerDiv} > span#recordsCalendarUpdated").text('true')
    return

  return

updateRecordsTable = (containerDiv, params) ->
  start_time = getDatetimePickerEpoch("#{containerDiv} div#startTime")
  end_time = getDatetimePickerEpoch("#{containerDiv} div#endTime") + 86400 # Add one day for 86400 seconds (60 * 60 * 24)
  request_params =
    check_time: "#{start_time}..#{end_time}"
    ui: true

  $.extend(request_params, params) if params # merge two objects

  $.ajax
    url: getBaseURL() + '/results.json'
    beforeSend: (xhr) ->
      recordsCalendarUpdated = $("#{containerDiv} > span#recordsCalendarUpdated").text() is 'true'

      if recordsCalendarUpdated
        # Force update since we changed calendar
        $("#{containerDiv} > span#recordsCalendarUpdated").text('false')
        return

      recordsIfNoneMatch = $("#{containerDiv} > span#recordsIfNoneMatch").text()
      recordsIfModifiedSince = $("#{containerDiv} > span#recordsIfModifiedSince").text()

      if recordsIfNoneMatch isnt '' and recordsIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', recordsIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', recordsIfModifiedSince)

      return
    data: request_params
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for record in data
          record[7] = dateToString(new Date(record[7] * 1000))

        columns = [
          { "sTitle": "名称" },
          { "sTitle": "描述" },
          {
            "sTitle": "读数",
            "sClass": "center"
          },
          {
            "sTitle": "正常范围",
            "sClass": "center"
          },
          {
            "sTitle": "状态",
            "sClass": "center"
          }
          { "sTitle": "备注" },
          {
            "sTitle": "条形码",
            "sClass": "center"
          },
          { "sTitle": "检测时间" }
        ]
        if $("#{containerDiv} table#recordsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#recordsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#recordsTable_wrapper").remove()
        $("#{containerDiv} > div").append('<table id="recordsTable"></table>')
        $("#{containerDiv} table#recordsTable").dataTable
          'aaData': data,
          'aoColumns': columns
          'fnRowCallback': (nRow, aaData, iDisplayIndex ) ->
            switch aaData[4]
              when '异常'
                $(nRow).addClass('redBackground')
              when '警告'
                $(nRow).addClass('yellowBackground')
            return

        $("#{containerDiv} > span#recordsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#recordsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified:true,
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

    updateChart('div#historyDiv', {barcode: _val})
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
  start_time = getDatetimePickerEpoch("#{containerDiv} div#startTime")
  end_time = getDatetimePickerEpoch("#{containerDiv} div#endTime") + 86400 # Add one day for 86400 seconds (60 * 60 * 24)
  request_params = { check_time: "#{start_time}..#{end_time}" }
  _id = params.id
  _barcode = params.barcode
  unless _barcode is undefined
    request_params.barcode = true
    _id = _barcode

  $('div#chartDiv').html('')
  $.ajax
    url: getBaseURL() + "/points/#{_id}/history.json?aggregate=30"
    data: request_params
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
         $('div#errorBanner, div#infoBanner').hide()
         if data.result.length is 0
           $('div#noHistoryBanner').show()
         else
           $('div#noHistoryBanner').hide()
           _point = data.point
           $("#{containerDiv} input#barcodeInput").val(_point.barcode) if _point.barcode
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
               $('div#noHistoryBanner').show()

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

setupManageUsersDiv = (containerDiv) ->
  $("#{containerDiv} button#btnDeleteUser").click ->
    _selectedTr = $('table#usersTable > tbody > tr.mediumSeaGreenBackground')
    if _selectedTr.length == 0
      alert '请选择用户！'
    else
      oTable = $("#{containerDiv} table#usersTable").dataTable()
      row = oTable.fnGetData(_selectedTr[0])
      if confirm("您确定要删除用户 #{row[1]} #{row[2]} 吗？")
        alert row[0]

    return

  $("#{containerDiv} button#btnAddNewUser").click ->
    $("#{containerDiv} div#createUserDiv").show()
    $("#{containerDiv} div#usersTableDiv, #{containerDiv} div#add_delete_buttons").hide()
    return

  $("#{containerDiv} button#btnCancelCreateUser").click ->
    $("#{containerDiv} div#createUserDiv").hide()
    $("#{containerDiv} div#usersTableDiv, #{containerDiv} div#add_delete_buttons").show()
    return

  $("#{containerDiv} button#btnCreateUser").click ->
    createUserDiv = "#{containerDiv} div#createUserDiv"
    userInfo = {}
    return unless validateUserForm(createUserDiv, userInfo)

    user_role = $("#{createUserDiv} select#userRole option:selected").val()
    console.log userInfo

    # TODO: ajax call
    $("#{createUserDiv} input#user_name, #{createUserDiv} input#user_email, #{createUserDiv} input#user_password").val('')
    $(createUserDiv).hide()
    $("#{containerDiv} div#usersTableDiv, #{containerDiv} div#add_delete_buttons").show()
    return

  return

updateUsersTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/users.json?ui=true'
    beforeSend: (xhr) ->
      usersIfNoneMatch = $("#{containerDiv} > span#usersIfNoneMatch").text()
      usersIfModifiedSince = $("#{containerDiv} > span#usersIfModifiedSince").text()

      if usersIfNoneMatch isnt '' and usersIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', usersIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', usersIfModifiedSince)

      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for record in data
          for i in [4, 5, 8, 9]
            record[i] = dateToString(new Date(record[i] * 1000))

          switch record[3]
            when 0
              record[3] = '管理员'
            when 1
              record[3] = '高级用户'
            when 2
              record[3] = '普通用户'

        columns = [
          { "sTitle": "ID" },
          { "sTitle": "用户名" },
          { "sTitle": "邮箱" },
          {
            "sTitle": "用户级别",
            "sClass": "center"
          },
          { "sTitle": "本次登入时间" },
          { "sTitle": "上次登入时间" },
          { "sTitle": "本次登入IP地址" },
          { "sTitle": "上次登入IP地址" },
          { "sTitle": "创建时间" },
          { "sTitle": "最近更新时间" }
        ]
        if $("#{containerDiv} table#usersTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#usersTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#recordsTable_wrapper").remove()
        $("#{containerDiv} div#usersTableDiv").append('<table id="usersTable"></table>')
        $("#{containerDiv} table#usersTable").dataTable
          'aaData': data
          'aoColumns': columns
          'aaSorting': [[ 3, 'desc' ]]
          'fnRowCallback': (nRow, aaData, iDisplayIndex ) ->
            switch aaData[3]
              when '高级用户'
                $(nRow).addClass('darkBlueTextColor')
              when '管理员'
                $(nRow).addClass('darkGreenTextColor')
              when '用户'
                $(nRow).addClass('darkCyanTextColor')
            return

        oTable = $("#{containerDiv} table#usersTable").dataTable()
        oTable.fnSetColumnVis(0, false)
        $('table#usersTable > tbody > tr').click (e) ->
          $('table#usersTable > tbody > tr.mediumSeaGreenBackground').removeClass('mediumSeaGreenBackground')
          $(this).addClass('mediumSeaGreenBackground')
          return

        $("#{containerDiv} > span#usersIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#usersIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified:true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

setupManageDataDiv = ->
  $('form#uploadFile').fileupload
    url: getBaseURL() + '/file.json',
    dataType: 'json',
    done: (e, data)->
      console.log "Done", data.result
      $('div#uploadInfo').addClass('alert-success').text('上传成功！').show()
      return

  return