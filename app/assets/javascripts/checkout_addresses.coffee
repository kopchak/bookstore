# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.checkbox_use_billing').change ->
    if $(this).attr('checked')
      $(this).removeAttr('checked')
      $('.shipping_address_form').show(200)
    else
      $(this).attr('checked', 'checked')
      $('.shipping_address_form').hide(200)
  false

  items_price = parseFloat($('.discount').prev('h5').text().replace(/[^0-9.]/g, ''))
  discount_amount = parseFloat($('.discount').text().replace(/[^0-9.]/g, '')) || 0
  order_total_price = (items_price - discount_amount).toFixed(2)
  $('.discount').next('h5').text('ORDER TOTAL: $' + order_total_price)