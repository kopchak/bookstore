# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  if $('.discount_overview').text()
      items_price = parseFloat($('.discount_overview').prev('h5').prev('h5').text().replace(/[^0-9.]/g, ''))
      delivery_cost = parseFloat($('.discount_overview').prev('h5').text().replace(/[^0-9.]/g, ''))
      discount_amount = parseFloat($('.discount_overview').text().replace(/[^0-9.]/g, ''))
      order_total_price = (items_price + delivery_cost - discount_amount).toFixed(2)
      $('.order_total_price_info_confirm').children('h5').text('ORDER TOTAL: $' + order_total_price)
  # else
  #   items_price = parseFloat($('.subtotal_overview').text().replace(/[^0-9.]/g, ''))
  #   console.log(items_price)
  #   delivery_cost = parseFloat($('.discount_overview').prev('h5').text().replace(/[^0-9.]/g, ''))
  #   order_total_price = (items_price + delivery_cost - discount_amount).toFixed(2)
  #   $('.order_total_price_info_confirm').children('h5').text('ORDER TOTAL: $' + order_total_price)