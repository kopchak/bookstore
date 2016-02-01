# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.books_qty_show').change ->
      book_qty = $(this).val()
      book_price = $(this).prev('.book_price').text().replace(/[^0-9.]/g, '')
      item_price = (book_price * book_qty).toFixed(2)
      $(this).next('#order_item_book_id').next('#order_item_price').val(item_price)
    false