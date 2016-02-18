# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#credit_card_number').keyup ->
    if @value != @value.replace(/[^0-9\.]/g, '')
      @value = @value.replace(/[^0-9\.]/g, '')
    return

  $('#credit_card_cvv').keyup ->
    if @value != @value.replace(/[^0-9\.]/g, '')
      @value = @value.replace(/[^0-9\.]/g, '')
    return


  items_price = parseFloat($('.discount_cc').prev('h5').prev('h5').text().replace(/[^0-9.]/g, ''))
  delivery_cost = parseFloat($('.order_summary_info_credit_card').find('.delivery_price').text().replace(/[^0-9.]/g, ''))
  discount_amount = parseFloat($('.discount_cc').text().replace(/[^0-9.]/g, '')) || 0
  order_total_price = (items_price + delivery_cost - discount_amount).toFixed(2)
  $('.discount_cc').next('h5').text('ORDER TOTAL: $' + order_total_price)
