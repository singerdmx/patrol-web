###
   Global variables
###
window.defaultAjaxCallTimeout = 60000 # 1 min timeout default for Ajax call

# Calendar widget
window.datetimePickerSettings =
  pickTime: false
  language: 'zh',
  pick12HourFormat: true

# Open a new window and display error message in new page
window.showErrorPage = (errorPageContent) ->
  errorWindow = window.open('','Error')
  errorWindow.document.write(errorPageContent)
  errorWindow.document.close()
  return

# Misc
Array::last = -> @[@length - 1]
