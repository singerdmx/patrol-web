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

  # 更新button
  $('button#updateRecordsTableButton').click (e) ->
    updateRecordsTable()
    return
  return

updateRecordsTable = ->
  startTime = $('div#startTime').data('datetimepicker').getLocalDate()
  endTime = $('div#endTime').data('datetimepicker').getLocalDate()
  $.ajax
    url: 'http://localhost:3000/results.json'
    beforeSend: (xhr) ->
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
        data = [
          [ "Trident", "Internet Explorer 4.0", "Win 95+", 4, "X" ],
          [ "Trident", "Internet Explorer 5.0", "Win 95+", 5, "C" ],
          [ "Trident", "Internet Explorer 5.5", "Win 95+", 5.5, "A" ],
          [ "Trident", "Internet Explorer 6.0", "Win 98+", 6, "A" ],
          [ "Trident", "Internet Explorer 7.0", "Win XP SP2+", 7, "A" ],
          [ "Gecko", "Firefox 1.5", "Win 98+ / OSX.2+", 1.8, "A" ],
          [ "Gecko", "Firefox 2", "Win 98+ / OSX.2+", 1.8, "A" ],
          [ "Gecko", "Firefox 3", "Win 2k+ / OSX.3+", 1.9, "A" ],
          [ "Webkit", "Safari 1.2", "OSX.3", 125.5, "A" ],
          [ "Webkit", "Safari 1.3", "OSX.3", 312.8, "A" ],
          [ "Webkit", "Safari 2.0", "OSX.4+", 419.3, "A" ],
          [ "Webkit", "Safari 3.0", "OSX.4+", 522.1, "A" ]
        ]
        columns = [
          { "sTitle": "名称" },
          { "sTitle": "描述" },
          { "sTitle": "运行状态" },
          {
            "sTitle": "条形码",
            "sClass": "center"
          },
          {
            "sTitle": "读数",
            "sClass": "center"
          }
        ]
        oTable = $('table#recordsTable').dataTable();
        oTable.fnDestroy() unless oTable?
        $('div#recordsTable_wrapper').remove()
        $('div#recordsDiv > div').append('<table id="recordsTable"></table>')
        $('table#recordsTable').dataTable
          "aaData": data,
          "aoColumns": columns

        $('span#recordsIfNoneMatch').text(jqHXR.getResponseHeader('Etag'))
        $('span#recordsIfModifiedSince').text(jqHXR.getResponseHeader('Last-Modified'))
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    dataType: "json",
    timeout: defaultAjaxCallTimeout

  return