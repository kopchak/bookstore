# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  # console.log('ready')
  $('#credit_card_number').keyup ->
    if @value != @value.replace(/[^0-9\.]/g, '')
      @value = @value.replace(/[^0-9\.]/g, '')
    return

  $('#credit_card_cvv').keyup ->
    if @value != @value.replace(/[^0-9\.]/g, '')
      @value = @value.replace(/[^0-9\.]/g, '')
    return

