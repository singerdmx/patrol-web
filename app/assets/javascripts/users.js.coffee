$ ->
  onSidebarClick()
  $('div.containerDiv').first().show()
  setupRecordsDiv()
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
        updateRecordsTable()
    return
  return

setupRecordsDiv = ->
  # Calendar widget
  datetimePickerSettings =
    pickTime: false
    language: 'zh',
    pick12HourFormat: true
  $('div#startTime').datetimepicker(datetimePickerSettings)
  $('div#endTime').datetimepicker(datetimePickerSettings)
  startTimePicker = $('div#startTime').data('datetimepicker')
  endTimePicker = $('div#endTime').data('datetimepicker')
  today = getToday()
  endTimePicker.setLocalDate(today)
  startTimePicker.setLocalDate(today.addDays(-1))
  $('div.datepicker-days, div#startTime, div#endTime').click ->
    $('span#recordsCalendarUpdated').text('true')
    return

  # 更新button
  $('button#updateRecordsTableButton').click (e) ->
    updateRecordsTable()
    return
  return

updateRecordsTable = ->
  startTime = $('div#startTime').data('datetimepicker').getLocalDate()
  endTime = $('div#endTime').data('datetimepicker').getLocalDate()
  $.ajax
    url: getBaseURL() + '/results.json'
    beforeSend: (xhr) ->
      recordsCalendarUpdated = $('span#recordsCalendarUpdated').text() is 'true'

      if recordsCalendarUpdated
        # Force update since we changed calendar
        $('span#recordsCalendarUpdated').text('false')
        return

      recordsIfNoneMatch = $('span#recordsIfNoneMatch').text()
      recordsIfModifiedSince = $('span#recordsIfModifiedSince').text()

      if recordsIfNoneMatch isnt '' and recordsIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', recordsIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', recordsIfModifiedSince)

      return
    data:
      start_time: startTime.toString()
      end_time: endTime.toString()
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
          { "sTitle": "检测时间" },
        ]
        oTable = $('table#recordsTable').dataTable();
        oTable.fnDestroy() unless oTable?
        $('div#recordsTable_wrapper').remove()
        $('div#recordsDiv > div').append('<table id="recordsTable"></table>')
        $('table#recordsTable').dataTable
          "aaData": aaData,
          "aoColumns": columns

        $('span#recordsIfNoneMatch').text(jqHXR.getResponseHeader('Etag'))
        $('span#recordsIfModifiedSince').text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    dataType: "json",
    timeout: defaultAjaxCallTimeout

  return