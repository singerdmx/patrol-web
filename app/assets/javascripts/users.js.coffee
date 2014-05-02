$ ->
  return unless getPageTitle() is '巡检 | 用户'
  setupSidebar()
  $('div.containerDiv').first().show()
  setupRecordsDiv('div#preferencesDiv', { preference: true })
  updateRecordsTable('div#preferencesDiv', { preference: true })
  setupTreeViewControlButtons('div#routesDiv')
  setupRecordsDiv('div#recordsDiv')

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
    return
  return

setupTreeViewControlButtons = (containerDiv) ->
  $('div#routesTreeControlButtons > button#collapseTree').click ->
    $("#{containerDiv} > div#routesTree > ul.media-list > li.media > a.pull-left > img[src$='minus.png']").trigger('click')
    return
  $('div#routesTreeControlButtons > button#openTree').click ->
    $("#{containerDiv} > div#routesTree > ul.media-list > li.media > a.pull-left > img[src$='plus.png']").trigger('click')
    return
  $('div#routesTreeControlButtons > button#updatePreferences').click ->
    updatePreferences(containerDiv)
    $("#{containerDiv} > span#preferencesUpdated").text('false')
    return
  return

updatePreferences = (containerDiv) ->
  preferences = {}
  for img in $("#{containerDiv} > div#routesTree ul.media-list > li.media > a.pull-left > img[src$='care.png']")
    id = $(img).attr('data-id')
    preferences[id] = true

  # TODO: make ajax call to server
  for preference in Object.keys(preferences)
    alert parseInt(preference)
  return

renderTreeView = (containerDiv) ->
  $.ajax
    url: getBaseURL() + '/routes.json'
    data:
      group_by_asset: true
      ui: true
    beforeSend: (xhr) ->
      routesTreeIfNoneMatch = $("#{containerDiv} > span#routesTreeIfNoneMatch").text()
      routesTreeIfModifiedSince = $("#{containerDiv} > span#routesTreeIfModifiedSince").text()

      if routesTreeIfNoneMatch isnt '' and routesTreeIfModifiedSince isnt ''
        xhr.setRequestHeader('If-None-Match', routesTreeIfNoneMatch)
        xhr.setRequestHeader('If-Modified-Since', routesTreeIfModifiedSince)

      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $(containerDiv).html('')
        buildTreeNode($(containerDiv), data)
        bindTreeViewClick(containerDiv)
        $("#{containerDiv} > span#routesTreeIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#routesTreeIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

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

setupRecordsDiv = (containerDiv, params) ->
  # Calendar widget
  $("#{containerDiv} div#startTime").datetimepicker(datetimePickerSettings)
  $("#{containerDiv} div#endTime").datetimepicker(datetimePickerSettings)
  startTimePicker = $("#{containerDiv} div#startTime").data('datetimepicker')
  endTimePicker = $("#{containerDiv} div#endTime").data('datetimepicker')
  today = getToday()
  endTimePicker.setLocalDate(today)
  startTimePicker.setLocalDate(today.addDays(-1))
  $("#{containerDiv} div#startTime > span.add-on, #{containerDiv} div#endTime > span.add-on, #{containerDiv} div#startTime, #{containerDiv} div#endTime").click ->
    $("#{containerDiv} > span#recordsCalendarUpdated").text('true')
    return

  # 更新button
  $("#{containerDiv} button#updateRecordsTableButton").click (e) ->
    updateRecordsTable(containerDiv, params)
    return
  return

updateRecordsTable = (containerDiv, params) ->
  start_time = getDatetimePickerEpoch("#{containerDiv} div#startTime")
  end_time = getDatetimePickerEpoch("#{containerDiv} div#endTime")
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

confirmExit = ->
  if $('div#routesDiv > span#preferencesUpdated').text() is 'true'
    '您在“我的路线”页面有更新但未点击“更新我的关注”按钮，还要继续离开本页吗？'