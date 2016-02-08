# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.button_remove_account').attr('disabled', 'disabled')
  $('.button_remove_account').css('color', 'darkgray')

  $('#confirm_remove_account').change ->
    if $(this).attr('checked')
      $(this).removeAttr('checked')
      $('.button_remove_account').attr('disabled', 'disabled')
      $('.button_remove_account').css('color', 'darkgray')
    else
      $(this).attr('checked', 'checked')
      $('.button_remove_account').removeAttr('disabled')
      $('.button_remove_account').css('color', 'white')
  false