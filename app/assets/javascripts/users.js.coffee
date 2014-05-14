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
        updateRouteList(containerDiv)
      when 'preferences'
        updateRecordsTable(containerDiv, { preference: true })
      when 'records'
        updateRecordsTable(containerDiv)
    return
  return

setupRoutesDiv  = (containerDiv) ->
  $("#{containerDiv} div#routeList, #{containerDiv} div#routeDetails").height($(document).height() * 0.8)
  $("#{containerDiv} ul#routeListGroup").sortable(
    helper : 'clone',
    update: (event, ui) ->
      route_id = $(ui.item[0]).data('id')
      for _li, i in $("#{containerDiv} ul#routeListGroup > li")
        if $(_li).data('id') is route_id
          _treeNode = $("#{containerDiv} div#routesTree > ul[data-id='#{route_id}']")
          $("#{containerDiv} div#routesTree > ul:nth-child(#{i+1})").before(_treeNode)
          break

      return
  )
  setupTreeViewControlButtons(containerDiv)
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
        _$ul = $("#{containerDiv} ul.list-group")
        _$ul.html('')

        for route in data
          _$ul.append "
            <li class='list-group-item' data-id='#{route.id}'>
              <span class='badge'>#{route.points.length}</span>
              #{route.name}</li>"

        setupRouteListClick(containerDiv)
        $("#{containerDiv} > span#routesIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#routesIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

        renderTreeView("#{containerDiv} div#routesTree")
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

renderTreeView = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/routes.json'
    data:
      group_by_asset: true
      ui: true
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $(containerDiv).html('')
        buildTreeNode($(containerDiv), data)
        bindTreeViewClick(containerDiv)

        $("#{containerDiv} > ul").hide()
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
        $('div#routesDiv > span#preferencesUpdated').text('true')
        syncSamePointImg(containerDiv, img, pic)

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
    updateChart('div#historyDiv', {barcode: $("#{containerDiv} input#barcodeInput").val()})
    return

  return

updateChart = (containerDiv, params) ->
  start_time = getDatetimePickerEpoch("#{containerDiv} div#startTime")
  end_time = getDatetimePickerEpoch("#{containerDiv} div#endTime") + 86400 # Add one day for 86400 seconds (60 * 60 * 24)
  request_params = { check_time: "#{start_time}..#{end_time}" }
  _id = params.id
  _barcode = params.barcode
  if _barcode
    request_params.barcode = true
    _id = _barcode

  $('div#chartDiv').html('')
  $.ajax
    url: getBaseURL() + "/points/#{_id}/history.json?aggregate=30"
    data: request_params
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
         if data.result.length is 0
           $('div#noHistoryBanner').show()
         else
           $('div#noHistoryBanner').hide()
           _point = data.point
           $("#{containerDiv} input#barcodeInput").val(_point.barcode) if _point.barcode
           title = "#{_point.name}   #{_point.description}"
           switch _point.category
             when 30, 50
               if data.group
                 renderHighLowChart('chartDiv', title, data.result)
               else
                 renderLineChart('chartDiv', title, data.result)
             else
               $('div#noHistoryBanner').show()

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

renderHighLowChart = (chartId, title, data) ->
  _ticks = [[0, ' ']]
  _hightlight_note = []
  _line = []
  _min = data[0].min.result
  _max = data[0].max.result

  for datum, i in data
    _range = dateRangeToString(new Date(datum.start_time * 1000), new Date(datum.end_time * 1000))
    _min = datum.min.result if datum.min.result < _min
    _max = datum.max.result if datum.max.result > _max
    _ticks.push([i+1, _range])
    _line.push([i+1, datum.max.result, datum.min.result])
    _hightlight_note.push("&nbsp;#{_range}<br/>
      &nbsp;#{datum.count}个巡检点<br/>
      &nbsp;最大值： #{datum.max.result}  （#{dateToString(new Date(datum.max.check_time * 1000))}）<br/>
      &nbsp;最小值： #{datum.min.result}   （#{dateToString(new Date(datum.min.check_time * 1000))}）")

  _ticks.push([data.length+1, ' '])
  _min *= if _min > 0 then 0.98 else 1.02
  _max *= if _max > 0 then 1.02 else 0.98
  _plot_setting = {
    title: title,
    axes: {
      xaxis: {
        ticks: _ticks,
        tickRenderer: $.jqplot.CanvasAxisTickRenderer,
        tickOptions: {
          angle: 80
        },
      },
      yaxis: {
        min: _min,
        max: _max,
        tickOptions: {
          formatString: '%.0f'
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
        _hightlight_note[pointIndex]
      show: true,
      showMarker: false,
      tooltipLocation: 'se',
      formatString:'%s'
    }
  }

  $.jqplot(
    chartId,
    [_line],
    _plot_setting
  )

  return

renderLineChart = (chartId, title, data) ->
  _ticks = [[0, ' ']]
  _hightlight_note = []
  _line = []
  _max = _min = data[0].min.result

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
  _plot_setting = {
    title: title,
    axes: {
      xaxis: {
        ticks: _ticks,
        tickRenderer: $.jqplot.CanvasAxisTickRenderer,
        tickOptions: {
          angle: 80
        },
      },
      yaxis: {
        min: _min,
        max: _max,
        tickOptions: {
          formatString: '%.0f'
        }
      }
    }
    series: [{
      rendererOptions:{
        lineWidth: 2,
        markerOptions: { style:'circle' }
      }
    }],
    highlighter: {
      tooltipContentEditor: (str, seriesIndex, pointIndex) ->
        _hightlight_note[pointIndex]
      show: true,
      showMarker: false,
      tooltipLocation: 'se'
    }
  }

  $.jqplot(
    chartId,
    [_line],
    _plot_setting
  )

  return

confirmExit = ->
  if $('div#routesDiv > span#preferencesUpdated').text() is 'true'
    '您在“我的路线”页面有更新但未点击“更新我的关注”按钮，还要继续离开本页吗？'