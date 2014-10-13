###
   Global variables
###
window.defaultAjaxCallTimeout = 60000 # 1 min timeout default for Ajax call

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
window.removeFlashNotice = ->
  setTimeout( ->
    $('div.alert.alert-notice, div.alert.alert-success, div.alert.alert-error').remove()
    return
  , 15000)

  return

Array::last = -> @[@length - 1]

window.dateToShortString = (date) ->
  "#{date.getFullYear()}年#{pad2(date.getMonth()+1)}月#{pad2(date.getDate())}日"

window.dateToString = (date) ->
  "#{dateToShortString(date)} #{pad2(date.getHours())}:#{pad2(date.getMinutes())}"

window.dateRangeToString = (start_time, end_time) ->
  start_time_string = dateToShortString(start_time)
  end_time_string = dateToShortString(end_time)
  return start_time_string if start_time_string is end_time_string
  "#{start_time_string} － #{end_time_string}"

window.changePasswordType = (element) ->
  switch $(element).attr('type')
    when 'password'
      $(element).attr('type', 'text')
    when 'text'
      $(element).attr('type', 'password')

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

###
   Graphs
###
chart_x_tick_angle = 45

window.getCanvasOverlayObjects = (_point) ->
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

window.renderHighLowChart = (chartId, title, data, _min, _max, canvasOverlayObjects) ->
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

window.renderLineChart = (chartId, title, data, _min, _max, canvasOverlayObjects) ->
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

window.renderBarChart = (chartId, title, data, group, choice) ->
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
