# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  discount = parseFloat($('.discount_deliveries').text().replace(/[^0-9.]/g, '')) || 0
  delivery_price = parseFloat($('.delivery_price_info').text().replace(/[^0-9.]/g, ''))
  order_items_price = parseFloat($('.sum_order_items').text().replace(/[^0-9.]/g, ''))
  order_price = (order_items_price + delivery_price - discount).toFixed(2)
  $('.order_total_price').text('ORDER TOTAL: $' + order_price)

  $('.delivery').change ->
    delivery_price = parseFloat($(this).text().replace(/[^0-9.]/g, ''))
    discount = parseFloat($('.discount_deliveries').text().replace(/[^0-9.]/g, '')) || 0
    order_items_price = parseFloat($('.sum_order_items').text().replace(/[^0-9.]/g, ''))
    order_price = (order_items_price + delivery_price - discount).toFixed(2)
    $('.delivery_price_info').text('SHIPPING: $' + delivery_price.toFixed(2))
    $('.order_total_price').text('ORDER TOTAL: $' + order_price)
  false