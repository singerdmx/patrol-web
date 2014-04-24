$ ->
  onSidebarClick()
  return

# users show
onSidebarClick = ->
  $('#sidebar ul li').click (e) ->
    $('#sidebar ul li.active').removeClass('active')
    $(this).addClass('active')
    return
