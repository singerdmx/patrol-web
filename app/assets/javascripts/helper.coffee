###
   Global variables
###
window.defaultAjaxCallTimeout = 60000 # 1 min timeout default for Ajax call
window.chart_x_tick_angle = 45

# Open a new window and display error message in new page
window.showErrorPage = (errorPageContent) ->
  errorWindow = window.open('','Error')
  errorWindow.document.write(errorPageContent)
  errorWindow.document.close()
  return

# validate entries in user form before submission, return true/false
window.validateUserForm = (containerDiv, userInfo) ->
  userInfo = {} unless userInfo
  userName = $("#{containerDiv} input#user_name")
  if isInputValueEmpty(userName)
    alert '请填写用户名！'
    return false

  userInfo['name'] = userName.val()
  userEmail = $("#{containerDiv} input#user_email")
  unless isValidEmailAddress(userEmail.val())
    alert '您填写的电子邮箱无效，请修正！'
    return false

  userInfo['email'] = userEmail.val()
  userPassword = $("#{containerDiv} input#user_password")
  if isInputValueEmpty(userPassword)
    alert '请填写密码！'
    return false

  if $.trim(userPassword.val()).length < 8
    alert '密码太短！至少需要八个字符。'
    return false

  userInfo['password'] = userPassword.val()
  $user_password_confirmation = $("#{containerDiv} input#user_password_confirmation")
  if $user_password_confirmation.size() > 0 and $user_password_confirmation.val() isnt userPassword.val()
    alert '密码不相符！'
    return false

  true

# Misc
window.setTitle = (title) ->
  $('span#logo').text(title)
  $('small#footerTitle').text(title)
  $('body').removeClass('defaultBackgroundImage')
  return

window.removeFlashNotice = ->
  setTimeout( ->
    $('div.alert.alert-notice, div.alert.alert-success').remove()
    return
  , 15000)

  return

Array::last = -> @[@length - 1]

window.setXhrRequestHeader = (xhr, containerDiv, spanName) ->
  ifNoneMatch = $("#{containerDiv} span##{spanName}IfNoneMatch").text()
  ifModifiedSince = $("#{containerDiv} span##{spanName}IfModifiedSince").text()

  xhr.setRequestHeader('If-None-Match', ifNoneMatch)
  xhr.setRequestHeader('If-Modified-Since', ifModifiedSince)
  return

window.dateToShortString = (date) ->
  "#{date.getFullYear()}年#{pad2(date.getMonth()+1)}月#{pad2(date.getDate())}日"

window.dateToString = (date) ->
  "#{dateToShortString(date)} #{pad2(date.getHours())}:#{pad2(date.getMinutes())}"

window.dateRangeToString = (start_time, end_time) ->
  start_time_string = dateToShortString(start_time)
  end_time_string = dateToShortString(end_time)
  return start_time_string if start_time_string is end_time_string
  "#{start_time_string} － #{end_time_string}"

window.columnDateToString = (record, columns) ->
  for column in columns
    record[column] = dateToString(new Date(record[column] * 1000)) if record[column]

  return

window.changePasswordType = (element) ->
  switch $(element).attr('type')
    when 'password'
      $(element).attr('type', 'text')
    when 'text'
      $(element).attr('type', 'password')

  return

window.setupTreeViewControlButtons = (containerDiv) ->
  $("#{containerDiv} button#collapseTree").click ->
    $("#{containerDiv} ul.media-list > li.media > a.pull-left > img[src$='minus.png']").trigger('click')
    return
  $("#{containerDiv} button#openTree").click ->
    $("#{containerDiv} ul.media-list > li.media > a.pull-left > img[src$='plus.png']").trigger('click')
    return
  return

window.resetToPlaceholderValue = (elements) ->
  for element in elements
    placeholder_val = $(element).attr('placeholder')
    $(element).val(placeholder_val) if placeholder_val
  return

window.isInputValueEmpty = (input_element) ->
  placeholder_val = $(input_element).attr('placeholder')
  input = $(input_element).val()
  return true if $.trim(input) is ''
  if placeholder_val
    return true if input is placeholder_val
  false

window.removeParent = ->
  $(this).parent().remove()
  return

window.joinStringArrayWithBR = (array) ->
  if array
    array = array.join('<br/>')
  else
    array = ''

  array

window.setupAutocompleteInput = (relativeUrl, valueKey, containerDiv, inputElem, suggestions, idElement) ->
  $.ajax
    url: getBaseURL() + relativeUrl
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        for datum in data
          _value = null
          if typeof valueKey is 'string'
            _value = datum[valueKey]
          else if valueKey instanceof Array
            _value = (datum[v] for v in valueKey).join(' ')
          else
            console.error("valueKey #{valueKey} is invalid")

          suggestions.push({ value: _value, data: datum['id']})

        suggestions.sort (a,b) ->
          return if a.value >= b.value then 1 else -1

        $("#{containerDiv} #{inputElem}").autocomplete(
          lookup: suggestions,
          onSelect: (suggestion) ->
            idElement.text(suggestion.data)
            return
        )
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

window.renderTreeView = (url, containerDiv, ifModifiedSinceSpanId, params, hideTree, showDeleteIcon, buildTreeNode, bindTreeViewClick) ->
  request_params = { ui: true }
  $.extend(request_params, params) if params # merge two objects
  $.ajax
    url: getBaseURL() + url
    data: request_params
    beforeSend: (xhr) ->
      return if ifModifiedSinceSpanId is null

      ifNoneMatch = $("#{ifModifiedSinceSpanId}IfNoneMatch").text()
      ifModifiedSince = $("#{ifModifiedSinceSpanId}routesIfModifiedSince").text()

      xhr.setRequestHeader('If-None-Match', ifNoneMatch)
      xhr.setRequestHeader('If-Modified-Since', ifModifiedSince)

      return
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $(containerDiv).html('')
        buildTreeNode($(containerDiv), data, showDeleteIcon)
        bindTreeViewClick(containerDiv)

        $("#{containerDiv} > ul").hide() if hideTree is true
        unless ifModifiedSinceSpanId is null
          $("#{ifModifiedSinceSpanId}IfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
          $("#{ifModifiedSinceSpanId}IfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

window.setupCalendar = (containerDiv, defaultCalendarDaysRange) ->
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
    $("#{containerDiv} > span#calendarUpdated").text('true')
    return

  return

window.getTableParams = (containerDiv, params) ->
  startTime = getDatetimePickerEpoch("#{containerDiv} div#startTime")
  endTime = getDatetimePickerEpoch("#{containerDiv} div#endTime") + 86400 # Add one day for 86400 seconds (60 * 60 * 24)
  requestParams =
    check_time: "#{startTime}..#{endTime}"
    ui: true

  $.extend(requestParams, params) if params # merge two objects
  requestParams

window.getProblemsTableParams = (containerDiv, params) ->
  requestParams = getTableParams(containerDiv, params)
  $.extend(requestParams, { status: $("#{containerDiv} select#status option:selected").val() })
  requestParams

window.renderAssignedUserStatChart = (chartId, assignedUserStat, choice) ->
  _line = []
  _line.push(new Array()) for [1..choice.length]

  _ticks = []
  _values = []
  for k, v of assignedUserStat
    _ticks.push(k)
    _values.push(v)

  return if _ticks.length == 0

  _unassignedIndex = _ticks.indexOf('未分配')
  # move '未分配' to the last
  if _unassignedIndex >= 0
    _ticks.swap(_unassignedIndex, _ticks.length - 1)
    _values.swap(_unassignedIndex, _values.length - 1)

  for i in [0.._ticks.length-1]
    for j in [0..choice.length-1]
      _line[j].push(_values[i][choice[j]])

  _series = ({label: c} for c in choice)
  _plot_setting =
    title: "点检问题处理汇总"
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
    seriesColors: ['rgb(0, 0, 139)', 'rgb(0, 100, 0)', 'rgb(0, 139, 139)', 'rgb(255, 140, 0)', 'rgb(153, 50, 204)', 'rgb(184, 134, 11)']
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

  $("div##{chartId} div.jqplot-point-label").css('color', 'white')
  return

window.updateProblemsTable = (containerDiv, params) ->
  requestParams = getProblemsTableParams(containerDiv, params)

  $.ajax
    url: getBaseURL() + '/problem_list.json'
    beforeSend: (xhr) ->
      calendarUpdated = $("#{containerDiv} > span#calendarUpdated").text() is 'true'

      if calendarUpdated
        # Force update since we changed calendar
        $("#{containerDiv} > span#calendarUpdated").text('false')
        return

      setXhrRequestHeader(xhr, containerDiv, 'problems')
      return
    data: requestParams
    success: (data, textStatus, jqHXR) ->
      if jqHXR.status is 200
        $("#{containerDiv} div#assignedUserStatChartDiv").html('')
        statusEnum = ($(o).text().trim() for o in $("#{containerDiv} select#status").children('option'))
        statusEnum.remove(statusEnum.indexOf('全部')) # remove “全部”
        assignedUserStat = {}

        noMedia = true
        for record in data
          columnDateToString(record, [0])
          record[9] = dateToShortString(new Date(record[9] * 1000)) if record[9]
          record[11] = "<span class='sessionLink' data-session='#{record[11]}'>巡检记录</span>" if record[11] # 详情
          # record[12] is in form of [image_url, audio_url]
          if record[12][0] isnt null
            record[12][0] = "<a target='_blank' href='#{record[12][0]}'>图片</a>"

          if record[12][1] isnt null
            record[12][1] = "<a target='_blank' href='#{record[12][1]}'>音频</a>"

          if record[12][0] is null and record[12][1] is null
            record[12] = ''
          else
            noMedia = false
            record[12] = record[12].join('<br/>')

          status = record[7]
          assignedUser = record[6]
          assignedUser = '未分配' unless assignedUser
          unless assignedUserStat[assignedUser]
            assignedUserStat[assignedUser] = {}
            for _s in statusEnum
              assignedUserStat[assignedUser][_s] = 0

          assignedUserStat[assignedUser][status] += 1

        renderAssignedUserStatChart('assignedUserStatChartDiv', assignedUserStat, statusEnum)
        columns = [
          { 'sTitle': '日期' },
          {
            'sTitle': '提交人',
            'sClass': 'center'
          },
          {
            'sTitle': '机台信息',
            'sClass': 'center'
          },
          {
            'sTitle': '部位名称',
            'sClass': 'center'
          },
          {
            'sTitle': '内容',
            'sClass': 'center'
          },
          {
            'sTitle': '问题描述',
            'sClass': 'center'
          },
          {
            'sTitle': '责任人',
            'sClass': 'center'
          },
          {
            'sTitle': '状态',
            'sClass': 'center'
          },
          {
            'sTitle': '备注',
            'sClass': 'center'
          },
          { 'sTitle': '计划完成日期' },
          { 'sTitle': 'ID' },
          { 'sTitle': '详情' },
          {
            'sTitle': '媒体',
            'sClass': 'center',
            'sWidth': '24px'
          }
        ]
        if $("#{containerDiv} table#problemsTable > tbody[role='alert'] td.dataTables_empty").length is 0
          # when there is no records in table, do not destroy it. It is ok to initialize it which is not reinitializing.
          oTable = $("#{containerDiv} table#problemsTable").dataTable()
          oTable.fnDestroy() unless oTable?

        $("#{containerDiv} div#problemsTable_wrapper").remove()
        $("#{containerDiv} > div#problemListDiv").append('<table id="problemsTable"></table>')
        $("#{containerDiv} table#problemsTable").dataTable
          'aaData': data,
          'aoColumns': columns,
          'aaSorting': [[ 0, 'desc' ]]
          'fnRowCallback': (nRow, aaData, iDisplayIndex ) ->
            switch aaData[7]
              when '未完成'
                $(nRow).addClass('darkBlueTextColor')
              when '完成'
                $(nRow).addClass('darkGreenTextColor')
              when '取消'
                $(nRow).addClass('darkCyanTextColor')
              when '进行中'
                $(nRow).addClass('darkOrangeTextColor')
              when '部分完成'
                $(nRow).addClass('darkGoldenrodTextColor')
            return

        oTable = $("#{containerDiv} table#problemsTable").dataTable()
        oTable.fnSetColumnVis(10, false)
        oTable.fnSetColumnVis(12, false) if noMedia
        oTable.fnSetColumnVis(11, false) unless $('span#logo').text() is '巡检'

        $("#{containerDiv} table#problemsTable > tbody").on(
          'click',
          'tr',
        ->
          oTable = $("#{containerDiv} table#problemsTable").dataTable()
          oTable.$('tr').removeClass('mediumSeaGreenBackground')
          $(this).addClass('mediumSeaGreenBackground')
          return
        )

        $("#{containerDiv} table#problemsTable span.sessionLink").click ->
          session_id = $(this).data('session')
          $.ajax
            url: getBaseURL() + "/sessions/#{session_id}.json"
            dataType: 'json',
            success: (data, textStatus, jqHXR) ->
              if jqHXR.status is 200
                showSessionInRecordsTable(session_id, data.route,
                  dateToString(new Date(data.start_time * 1000)),
                  dateToString(new Date(data.end_time * 1000)),
                  data.start_time, data.end_time)
              return
            error: (jqXHR, textStatus, errorThrown) ->
              showErrorPage(jqXHR.responseText)
              return
            timeout: defaultAjaxCallTimeout
          return

        $("#{containerDiv} > span#problemsIfNoneMatch").text(jqHXR.getResponseHeader('Etag'))
        $("#{containerDiv} > span#problemsIfModifiedSince").text(jqHXR.getResponseHeader('Last-Modified'))

      return
    error: (jqXHR, textStatus, errorThrown) ->
      showErrorPage(jqXHR.responseText)
      return
    ifModified: true,
    dataType: 'json',
    timeout: defaultAjaxCallTimeout

  return

window.setupProblemsDiv = (containerDiv) ->
  setupCalendar(containerDiv, 30)

  # 状态选择改变
  $("#{containerDiv} select#status").change ->
    $("#{containerDiv} > span#calendarUpdated").text('true')
    return

  # 更新button
  $("#{containerDiv} button#updateProblemsTableButton").click (e) ->
    updateProblemsTable(containerDiv)
    return

  $("#{containerDiv} button#btnExportProblem").click ->
    requestParams = getProblemsTableParams(containerDiv)
    _url = getBaseURL() + '/problem_list/export.json?' + ("#{k}=#{v}" for k, v of requestParams).join('&')
    window.open(_url)
    return

  $("#{containerDiv} button#btnEditProblem").click ->
    oTable = $("#{containerDiv} table#problemsTable").dataTable()
    _selectedTr = oTable.$('tr.mediumSeaGreenBackground')
    if _selectedTr.length is 0
      alert '请选择问题！'
    else
      row = oTable.fnGetData(_selectedTr[0])
      id = row[10]
      $.ajax
        url: getBaseURL() + "/problem_list/#{id}.json"
        success: (data, textStatus, jqHXR) ->
          if jqHXR.status is 200
            $("#{containerDiv} span#problemId").text(id)
            $("#{containerDiv} span#problem_created_at").text(dateToString(new Date(data['created_at'] * 1000)))
            $("#{containerDiv} span#problem_created_by_user").text(data['created_by_user'])
            $("#{containerDiv} span#problem_name").text(data['name'])
            $("#{containerDiv} span#problem_description").text(data['description'])
            $("#{containerDiv} span#problem_area").text(data['area'])
            $("#{containerDiv} span#problem_point_description").text(data['point_description'])
            changeSelectByValue('problem_status', data['status'])
            $("#{containerDiv} textarea#problem_content").val(data['content'])
            $("#{containerDiv} input#problem_assigned_to_user").val(data['assigned_to_user'])
            $("#{containerDiv} span#problem_assigned_to_id").text(data['assigned_to_id'])
            $("#{containerDiv} div#problem_plan_date").datetimepicker(getDatetimePickerSettingsWithStartDate())
            planDatePicker = $("#{containerDiv} div#problem_plan_date").data('datetimepicker')
            planDatePicker.setLocalDate(if data['plan_date'] then new Date(data['plan_date'] * 1000) else 0)
            if data['image']
              $("#{containerDiv} div#problem_image").show()
              $("#{containerDiv} span#problem_image_link").html(
                "<a target='_blank' href='" + data['image'] + "'>链接</a>")
            else
              $("#{containerDiv} div#problem_image").hide()
            if data['audio']
              $("#{containerDiv} div#problem_audio").show()
              $("#{containerDiv} span#problem_audio_link").html(
                "<a target='_blank' href='" + data['audio'] + "'>链接</a>")
            else
              $("#{containerDiv} div#problem_audio").hide()

            _suggestions = []
            setupAutocompleteInput('/users.json', 'name', containerDiv, 'input#problem_assigned_to_user',
              _suggestions, $("#{containerDiv} span#problem_assigned_to_id"))

            $("#{containerDiv} button#btnSubmit").unbind('click')
            $("#{containerDiv} button#btnSubmit").click ->
              submitEditProblemForm(containerDiv, _suggestions)
              return

          return
        error: (jqXHR, textStatus, errorThrown) ->
          showErrorPage(jqXHR.responseText)
          return
        dataType: 'json',
        timeout: defaultAjaxCallTimeout

      $("#{containerDiv} div#editProblemsDiv").show()
      $("#{containerDiv} div#problemListDiv, #{containerDiv} div#editProblemListDiv, #{containerDiv} div#assignedUserStatChartDiv").hide()

    return

  $("#{containerDiv} button#btnReturn").click ->
    updateProblemsTable(containerDiv)
    $("#{containerDiv} div#editProblemsDiv").hide()
    $("#{containerDiv} div#problemListDiv, #{containerDiv} div#editProblemListDiv, #{containerDiv} div#assignedUserStatChartDiv").show()

    return

  return

submitEditProblemForm = (containerDiv, _suggestions) ->
  assignedUser = $("#{containerDiv} input#problem_assigned_to_user").val().trim()
  assignedToId = $("#{containerDiv} span#problem_assigned_to_id").text()
  valid = true

  if assignedUser is ''
    $("#{containerDiv} span#problem_assigned_to_id").text('')
    assignedToId = ''
  else
    _u = $.grep(
      _suggestions,
    (e) ->
      e.data.toString() is assignedToId
    )

    valid = false unless _u.length > 0 and _u[0].value is assignedUser

  unless valid
    alert '责任人填写错误！'
    return

  planDate = null
  unless $("#{containerDiv} div#problem_plan_date > input").val().trim() is ''
    try
      planDate = getDatetimePickerEpoch($("#{containerDiv} div#problem_plan_date"))
    catch err
      console.error(err)
      valid = false

  unless valid
    alert '计划完成日期填写错误！'
    return

  payload = {
    plan_date: planDate,
    assigned_to_id: assignedToId,
    status: $("#{containerDiv} select#problem_status").val(),
    content: $("#{containerDiv} textarea#problem_content").val()
  }
  $.ajax
    url: getBaseURL() + "/problem_list/#{$("#{containerDiv} span#problemId").text()}.json"
    type: 'PUT',
    contentType: 'application/json',
    data: JSON.stringify(payload),
    dataType: 'json',
    success: (data, textStatus, jqHXR) ->
      alert '更新成功'
      $("#{containerDiv} button#btnReturn").trigger('click')
      return
    error: (jqXHR, textStatus, errorThrown) ->
      alert jqXHR.responseJSON.message
      return
    timeout: defaultAjaxCallTimeout

  return