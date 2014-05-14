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

# Misc
Array::last = -> @[@length - 1]
  
  
window.dateToString = (date) ->
  "#{date.getFullYear()}年#{date.getMonth()+1}月#{date.getDate()}日 #{date.getHours()}:#{date.getMinutes()}"

window.dateToShortString = (date) ->
  "#{date.getFullYear()}年#{date.getMonth()+1}月#{date.getDate()}日"

window.dateRangeToString = (start_time, end_time) ->
  start_time_string = dateToShortString(start_time)
  end_time_string = dateToShortString(end_time)
  return start_time_string if start_time_string is end_time_string
  "#{start_time_string} － #{end_time_string}"
