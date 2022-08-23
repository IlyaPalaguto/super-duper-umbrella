class Train
	def initialize(numb)
		@numb = numb
		validate!
	end

	def validate!
		raise "Неправильный номер" if @numb.length < 3
	end
end

def create_train
	puts "Введите номер поезда"
	Train.new(gets.chomp)
end

def check_exceptions(action)
	try_quantity = 0
	begin
		action
		puts "Поезд успешно создан!"
	rescue RuntimeError => e
		try_quantity += 1
		puts "Ошибка: #{e.message}"
		retry if try_quantity < 3
	end
end

check_exceptions(create_train)


