# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.order_item_books_qty').change ->
    book_qty = $(this).val()
    book_price = $(this).prev('.book_price').text().replace(/[^0-9.]/g, '')
    order_item_id = $(this).parent('.order_item').attr('id')
    order_item_price = (book_price * book_qty).toFixed(2)
    $.ajax
      type: 'patch'
      url: "order_items/" + order_item_id
      data: 
        'order_item[quantity]': book_qty
        'order_item[price]': order_item_price
    $(this).next('.total_book_price').text('$' + order_item_price)
  false

  $('.order_item_books_qty').change ->
    order_price = 0
    $('.order_items').find('.total_book_price').map((indx, element) ->
      order_price += parseFloat($(element).text().replace(/[^0-9.]/g, ''))
      )
    order_price = order_price.toFixed(2)
    $('.total_order_price').text('$' + order_price)
  false

