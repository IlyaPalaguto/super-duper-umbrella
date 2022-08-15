basket = Hash.new
total_price = 0
loop do
	puts "Введите название товара: "
	product = gets.chomp
	break if product.downcase == "стоп"
	print "Количество: "
	product_qty = gets.chomp.to_i
	print "Цена за шт.: "
	product_price = gets.chomp.to_f

	basket[product.to_sym] = {qty: product_qty, price: product_price}
end
puts "В вашей корзине: "
basket.each do |product, info| 
	puts "#{product} (#{info[:qty]} шт.) - #{info[:qty] * info[:price]}$  "
end

basket.values.each {|info| total_price = total_price + info[:qty] * info[:price]}
puts "Общая сумма покупок - #{total_price}$"
