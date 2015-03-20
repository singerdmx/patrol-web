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
