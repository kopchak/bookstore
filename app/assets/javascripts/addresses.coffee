# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.checkbox_use_billing').change ->
    $(this).parent('.show_shipping_address_form').hide(200)
    $('.shipping_address_form').show(200)
    # console.log('changed')
  false