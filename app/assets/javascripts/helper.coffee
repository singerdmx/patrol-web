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
  user_name = $("#{containerDiv} input#user_name").val()
  if user_name is '用户名' or $.trim(user_name) is ''
    alert '请填写用户名！'
    return false

  userInfo['user_name'] = user_name
  user_email = $("#{containerDiv} input#user_email").val()
  unless isValidEmailAddress(user_email)
    alert '您填写的电子邮箱无效，请修正！'
    return false

  userInfo['user_email'] = user_email
  user_password = $("#{containerDiv} input#user_password").val()
  if $.trim(user_password) is ''
    alert '请填写密码！'
    return false

  if $.trim(user_password).length < 8
    alert '密码太短！至少需要八个字符。'
    return false

  userInfo['user_password'] = user_password
  $user_password_confirmation = $("#{containerDiv} input#user_password_confirmation")
  if $user_password_confirmation.size() > 0 and $user_password_confirmation.val() isnt user_password
    alert '密码不相符！'
    return false

  true

# Misc
window.removeFlashNotice = ->
  setTimeout( ->
    $('div.alert.alert-notice, div.alert.alert-success').remove()
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
