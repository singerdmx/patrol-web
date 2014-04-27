$ ->
  onSidebarClick()
  $('div.containerDiv').first().show()
  setupRecordsDiv('div#recordsDiv')
  bindTreeViewClick()
  return

# users show
onSidebarClick = ->
  $('#sidebar ul li').click (e) ->
    $('#sidebar ul li.active').removeClass('active')
    $(this).addClass('active')
    id = $(this).attr('id')
    containerDiv = "div##{id}Div"
    $('div.containerDiv').hide()
    $(containerDiv).show()
    switch id
      when 'records'
        updateRecordsTable(containerDiv)
    return
  return

bindTreeViewClick = ->
  $('ul.media-list > li.media > a.pull-left').click ->
    img = $(this).children('img.media-object.mediaListIcon')
    src = img.attr('src')
    pic = src.split('/').last()
    switch pic
      when 'minus.png'
        img.attr('src', src.replace(/minus.png/, 'plus.png'))
      when 'plus.png'
        img.attr('src', src.replace(/plus.png/, 'minus.png'))

    $(this).next('div.media-body').children('ul.media-list').toggle()
    return

  return

setupRecordsDiv = (containerDiv) ->
  # Calendar widget
  $("#{containerDiv} div#startTime").datetimepicker(datetimePickerSettings)
  $("#{containerDiv} div#endTime").datetimepicker(datetimePickerSettings)
  startTimePicker = $("#{containerDiv} div#startTime").data('datetimepicker')
  endTimePicker = $("#{containerDiv} div#endTime").data('datetimepicker')
  today = getToday()
  endTimePicker.setLocalDate(today)
  startTimePicker.setLocalDate(today.addDays(-1))
  $("#{containerDiv} div#startTime > span.add-on, #{containerDiv} div#endTime > span.add-on, #{containerDiv} div#startTime, #{containerDiv} div#endTime").click ->
    $("#{containerDiv} span#recordsCalendarUpdated").text('true')
    return

  # 更新button
  $("#{containerDiv} button#updateRecordsTableButton").click (e) ->
    updateRecordsTable(containerDiv)
    return
  return

updateRecordsTable = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/results.json'
    beforeSend: (xhr) ->
      recordsCalendarUpdated = $("#{containerDiv} span#recordsCalendarUpdated").text() is 'true'

      if recordsCalendarUpdated
        # Force update since we changed calendar
        $("#{containerDiv} span#recordsCalendarUpdated").text('false')
        return

      recordsIfNoneMatch = $("#{containerDiv} span#recordsIfNoneMatch").text()
      recordsIfModifiedSince = $("#{containerDiv} span#recordsIfModifiedSince").text()

      if recordsIfNoneMatch isnt '' and recordsIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', recordsIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', recordsIfModifiedSince)

      return
    data:
      start_time: getDatetimePickerEpoch("#{containerDiv} div#startTime")
      end_time: getDatetimePickerEpoch("#{containerDiv} div#endTime")
      ui: true
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        aaData = data.map (record) ->
          checkTime = new Date(record[7])
          record[7] = "#{checkTime.getFullYear()}年#{checkTime.getMonth()+1}月#{checkTime.getDate()}日 #{checkTime.getHours()}:#{checkTime.getMinutes()}"
          record

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
        oTable = $("#{containerDiv} table#recordsTable").dataTable();
        oTable.fnDestroy() unless oTable?
        $("#{containerDiv} div#recordsTable_wrapper").remove()
        $("#{containerDiv} > div").append('<table id="recordsTable"></table>')
        $("#{containerDiv} table#recordsTable").dataTable
          'aaData': aaData,
          'aoColumns': columns

        $("#{containerDiv} span#recordsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} span#recordsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return