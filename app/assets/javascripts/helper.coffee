###
   Global variables
###
window.defaultAjaxCallTimeout = 60000 # 1 min timeout default for Ajax call

$(document).ready ->
  alert 'Your current web browser does not support HTML5 Web Storage. This will cause malfunctioning of this site!' unless Storage?
  checkVersion()
  return

checkVersion = ->
  version = "0" # Version of current javascript
  currentVersion = localStorage.getItem("version")
  if !currentVersion or currentVersion != version
    localStorage.clear()
    localStorage.setItem("version", version)
  return

###
   Shared common functions
###

###
    localStorage is part of the new HTML5 specification and allows you to store and
    retrieve objects in a local database that lives in the browser. The interface is quite
    simple; in supported browsers a global variable named localStorage will be
    present. This variable has the following three important methods:
        localStorage.setItem(key, value)
        localStorage.getItem(key)
        localStorage.removeItem(key)
    Both the key and value parameters are strings. Strings stored in the localStorage
    variable hang around even when the page is refreshed. You can store up to 5 MB in
    the localStorage variable in most browsers.
    Because we want to store the to-do items as a complex object rather than a string,
    we use the commonly used technique of converting to and from a JSON object
    when setting and getting items from localStorage. To do so, we'll add two
    methods to the prototype of the Storage class, which will then be available on
    the global localStorage object.
    Here, we use the :: operator to add the setObj and getObj methods to the Storage
    class. These functions wrap the localStorage object's getItem and setItem
    methods by converting the object to and from JSON.
    Sample Use:
    randomId = (Math.floor Math.random()*999999)
    localStorage.setObj randomId,{
        id: randomId
        title: val
        completed: false
    }
###

Storage::setObj = (key, obj) ->
  @setItem key, JSON.stringify(obj)

Storage::getObj = (key) ->
  obj = @getItem(key)
  if (obj)
    JSON.parse obj
  else
    null

Storage::setDate = (key, date) ->
  @setItem key, date

Storage::getDate = (key) ->
  new Date @getItem(key)

# Open a new window and display error message in new page
window.showErrorPage = (errorPageContent) ->
  errorWindow = window.open('','Error')
  errorWindow.document.write(errorPageContent)
  errorWindow.document.close()
  return
