$ ->
  return unless getPageTitle() is '巡检 | 用户'
  setupSidebar()
  $('div.containerDiv').first().show()
  setupRecordsDiv('div#preferencesDiv', 1, { preference: true })
  updateRecordsTable('div#preferencesDiv', { preference: true })
  setupRoutesDiv('div#routesDiv')
  setupRecordsDiv('div#recordsDiv', 1)
  setupHistoryDiv('div#historyDiv')

  # Check on exiting page
  window.onbeforeunload = confirmExit
  return

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
        renderTreeView('div#routesTree')
      when 'preferences'
        updateRecordsTable(containerDiv, { preference: true })
      when 'records'
        updateRecordsTable(containerDiv)
      when 'history'
        updateChart()
    return
  return

setupRoutesDiv  = (containerDiv) ->
  $("#{containerDiv} div#routeList, #{containerDiv} div#routeDetails").height($(document).height() * 0.8)
  setupRouteList(containerDiv)
  setupTreeViewControlButtons(containerDiv)
  return

setupRouteList = (containerDiv) ->
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
        _$ul = $("#{containerDiv} ul.list-group")
        _$ul.html('')

        for route in data
          _$ul.append "
            <li class='list-group-item'>
              <span class='badge'>#{route.points.length}</span>
              <span class='hiddenSpan'>#{route.id}</span>
              #{route.name}</li>"

        setupRouteListClick(containerDiv)
        $("#{containerDiv} > span#routesIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#routesIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified:true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

setupRouteListClick = (containerDiv) ->
  $("#{containerDiv} ul.list-group > li.list-group-item")
  .mouseover ->
      $(this).addClass('blueBackground')
      return
  .mouseout ->
      $(this).removeClass('blueBackground')
      return

  return

setupTreeViewControlButtons = (containerDiv) ->
  $('div#routesTreeControlButtons button#collapseTree').click ->
    $("#{containerDiv} div#routesTree > ul.media-list > li.media > a.pull-left > img[src$='minus.png']").trigger('click')
    return
  $('div#routesTreeControlButtons button#openTree').click ->
    $("#{containerDiv} div#routesTree > ul.media-list > li.media > a.pull-left > img[src$='plus.png']").trigger('click')
    return
  $('div#routesTreeControlButtons button#updatePreferences').click ->
    updatePreferences(containerDiv)
    $("#{containerDiv} > span#preferencesUpdated").text('false')
    return
  return

updatePreferences = (containerDiv) ->
  _preferences = new HashSet()
  for img in $("#{containerDiv} div#routesTree ul.media-list > li.media > a.pull-left > img[src$='care.png']")
    id = $(img).attr('data-id')
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

renderTreeView = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/routes.json'
    data:
      group_by_asset: true
      ui: true
    beforeSend: (xhr) ->
      routesIfNoneMatch = $("#{containerDiv} > span#routesIfNoneMatch").text()
      routesIfModifiedSince = $("#{containerDiv} > span#routesIfModifiedSince").text()

      if routesIfNoneMatch isnt '' and routesIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', routesIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', routesIfModifiedSince)

      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $(containerDiv).html('')
        buildTreeNode($(containerDiv), data)
        bindTreeViewClick(containerDiv)
        $("#{containerDiv} > span#routesIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#routesIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

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
    parent.append "
    <ul class='media-list'>
      <li class='media'>
        <a class='pull-left'>
          <img src='/assets/#{nodeDatum.icon}' class='media-object mediaListIcon' data-id='#{nodeDatum.id}'/>
        </a>
        <div class='media-body'>
        <h4 class='media-heading'>#{nodeDatum.title}</h4>
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
        $('div#routesDiv > span#preferencesUpdated').text('true')
        syncSamePointImg(containerDiv, img, pic)

    $(this).next('div.media-body').children('ul.media-list').toggle()
    return

  return

syncSamePointImg = (containerDiv, img, pic) ->
  id = img.attr('data-id')
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
          checkTime = new Date(record[7])
          record[7] = "#{checkTime.getFullYear()}年#{checkTime.getMonth()+1}月#{checkTime.getDate()}日 #{checkTime.getHours()}:#{checkTime.getMinutes()}"

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
  setupCalendar(containerDiv, 7)
  return

updateChart = ->
  ohlc = [
    [1, 136.01, 139.5, 134.53, 139.48],
    [2, 143.82, 144.56, 136.04, 136.97],
    [3, 136.47, 146.4, 136, 144.67],
    [4, 124.76, 135.9, 124.55, 135.81],
    [5, 123.73, 129.31, 121.57, 122.5],
    [6, 127.37, 130.96, 119.38, 122.42],
    [7, 128.24, 133.5, 126.26, 129.19],
    [8, 122.9, 127.95, 122.66, 127.24],
    [9, 121.73, 127.2, 118.6, 123.9],
    [10, 120.01, 124.25, 115.76, 123.42],
  ]
  for o,i in ohlc
    n = []
    n.push(o[0])
    n.push(o[2])
    n.push(o[3])
#    n.push(o[4])
    ohlc[i] = n
  ticks = [[0, ' '], [1,'Dec 10'], [2,'Jan 11'], [3,'Feb 11'], [4,'Mar 11'], [5,'Apr 11'], [6,'May 11'], [7,'Jun 11'], [8,'Jul 11'], [9,'Aug 11'], [10,'Sept 11'], [11, ' ']]
  $.jqplot(
    'chartDiv',
    [ohlc],
    {
      title: '轴承 温度测量',
      axes: {
        xaxis: {
          label: '时间'
          ticks: ticks,
          tickRenderer: $.jqplot.CanvasAxisTickRenderer,
          tickOptions: {
            angle: 30
          },
        },
        yaxis: {
          min: 110,
          max: 150,
          tickOptions:{
            formatString:'%.0f'
          }
        }
      }
      series: [{
        renderer:$.jqplot.OHLCRenderer,
        rendererOptions:{
          lineWidth: 5
        }
      }],
      highlighter: {
        tooltipContentEditor: (str, seriesIndex, pointIndex) ->
          "<span>point: #{pointIndex}</span>"
        show: true,
        showMarker: false,
        tooltipLocation: 'se'
      }
    }
  )
  return

confirmExit = ->
  if $('div#routesDiv > span#preferencesUpdated').text() is 'true'
    '您在“我的路线”页面有更新但未点击“更新我的关注”按钮，还要继续离开本页吗？'