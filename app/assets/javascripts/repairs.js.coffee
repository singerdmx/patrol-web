$ ->
  return unless isRepairrPage()
  setTitle('报修')
  return

isRepairrPage = ->
  _pageTitle = getPageTitle()
  return true if _pageTitle in ['报修 | 用户', '报修 | 管理员', '报修 | 高级用户', '报修 | 维修工']
  false