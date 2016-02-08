# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
customer = Customer.create(email: 'admin@ua.org', admin: true, password: '12345678')

john_carmack = Author.create(firstname: "John", lastname: "Carmack")
category_mob_dev = Category.create(title: "Mobile development")
category_photography = Category.create(title: "Photography")
category_web_design = Category.create(title: "Web design")
category_web_dev = Category.create(title: "Web development")

delivery1 = Delivery.create(price: 5.00, title: 'UPS Ground')
delivery2 = Delivery.create(price: 10.00, title: 'UPS Two Day')
delivery3 = Delivery.create(price: 15.00, title: 'UPS One Day')

description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris imperdiet arcu nisl, sollicitudin lacinia arcu interdum id. Pellentesque lacinia aliquet condimentum. Fusce facilisis dui turpis, convallis semper ligula efficitur eu. In scelerisque ornare diam vitae fermentum. In sollicitudin et ante quis dictum. Nunc dignissim, neque non rhoncus condimentum, leo enim porta mi, luctus sollicitudin massa nisl sit amet lorem. Proin vitae lobortis velit, non tempus massa. Cras aliquam lacinia dapibus. Pellentesque luctus mi sem, non pharetra sapien bibendum eget. Curabitur id ornare magna. Nunc vehicula enim at nunc porttitor, eget mollis nunc ultrices. Nullam ut eleifend nibh, sed bibendum ligula. Aenean molestie laoreet ultrices. Proin lacinia orci id turpis consequat, vitae egestas ante dictum. Donec mauris dui, tempor vitae condimentum sed, maximus at libero.'

book_mob_dev = Book.create(title: "Book for mobile development", price: 14.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_mob_dev.id, description: description)
book_photography = Book.create(title: "Book how create photography", price: 11.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_photography.id, description: description)
book_web_design = Book.create(title: "Book how learn web design", price: 10.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_design.id, description: description)
book_web_dev1 = Book.create(title: "Book how learn web development1", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev2 = Book.create(title: "Book how learn web development2", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev3 = Book.create(title: "Book how learn web development3", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev4 = Book.create(title: "Book how learn web development4", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev5 = Book.create(title: "Book how learn web development5", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev6 = Book.create(title: "Book how learn web development6", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev7 = Book.create(title: "Book how learn web development7", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)
book_web_dev8 = Book.create(title: "Book how learn web development8", price: 17.35, stock_qty: 3, author_id: john_carmack.id, category_id: category_web_dev.id, description: description)

order_item = OrderItem.create(price: 28.70, quantity: 3, book_id: book_mob_dev.id)
order_item2 = OrderItem.create(price: 22.70, quantity: 2, book_id: book_photography.id)
order_item3 = OrderItem.create(price: 10.35, quantity: 1, book_id: book_web_design.id)

order = Order.create(total_price: 30.00, completed_date: '30-01-2016', state: "in_queue", customer_id: customer.id, delivery_id: delivery1.id)
order2 = Order.create(total_price: 45.00, completed_date: '31-01-2016', state: "in_delivery", customer_id: customer.id, delivery_id: delivery1.id)
order3 = Order.create(total_price: 50.00, completed_date: '01-02-2016', state: "delivered", customer_id: customer.id, delivery_id: delivery1.id)

order.order_items << order_item
order2.order_items << order_item2
order3.order_items << order_item3
