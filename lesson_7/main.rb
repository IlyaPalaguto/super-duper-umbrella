require_relative 'manufacturer_company'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'passanger_train'
require_relative 'cargo_train'
require_relative 'route.rb'
require_relative 'station'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passanger_carriage'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @cargos = []
  end

  def start
    loop do
      show_menu
			return if get_user_action == "exit"
    end
  end

  def show_menu
    puts  "    Меню:\n
		1 - Создать станцию
		2 - Создать поезд
		3 - Создать маршрут или управлять станциями в нем (добавлять, удалять)
		4 - Назначить маршрут поезду
		5 - Добавить вагон к поезду
		6 - Отцепить вагон от поезда
		7 - Переместить поезд по маршруту вперед или назад
		8 - Посмотреть список поездов на станции
		9 - Посмотреть список вагонов поезда
		10 - Посмотреть список станций
		11 - Занять место или заполнить вагон
		0 - Выйти из приложения"
  end
	
  def get_user_action
    puts "Введите цифру соответствующую действию"
    action = gets.chomp.to_i
    case action
    when 1
			error_handling {create_station}
    when 2
    	error_handling { create_train }
    when 3
      if get_correct_user_choice(2, "1 - Создать маршрут \n2 - Управлять станциями") == 1
	    	error_handling { create_route }
      else
        if get_correct_user_choice(2, "1 - Добавить станцию \n2 - Удалить станцию") == 1
          error_handling(1) {add_station_on_route}
				else
          error_handling(1) {delete_station_on_route}
        end
      end
    when 4
      set_route
    when 5
      add_car
    when 6
      remove_car
    when 7
      move_train
    when 8
			show_trains_on_station(station_user_choice)
    when 9 
      show_cargos_of_train(train_user_choice)
		when 10
			stations_list
		when 11
			error_handling(1) {take_seat_or_fill_value}
    when 0
      exit_app
    end
  end

	def get_correct_user_choice(answers_quantity, message)
		user_input = 0
		until (1..answers_quantity).cover?(user_input)
			puts message
			user_input = gets.chomp.to_i
		end
		return user_input
	end
	
	def error_handling(tryed_quantity = 3)
		yield
	rescue RuntimeError => e
		tryed_quantity -= 1
		puts "Ошибка: #{e.message}"
		puts "Попробуйте еще раз\n(осталось попыток: #{tryed_quantity})" if tryed_quantity != 0
		retry if tryed_quantity != 0
	end

	def take_seat_or_fill_value
		train = train_user_choice
		show_cargos_of_train(train)
		car = train.cars[get_correct_user_choice(train.cars.length, "Выберете вагон") - 1]
		if car.class == CargoCarriage
			raise "Вагон полный" if car.free_value == 0
			puts "На сколько заполнить вагон?"
			value = gets.chomp.to_i
			raise "Нет столько места" if value > car.free_value
			raise "Поезд не находится в данный момент на станции" if car.fill_value(value).nil?
			puts "Вагон успешно заполнен. Осталось свободного объема: #{car.free_value}"
		else 
			raise "Вагон полный" if car.free_seats == 0
			raise "Поезд не находится в данный момент на станции" if car.take_seat.nil?
			puts "Место успешно занято. Осталось свободных мест: #{car.free_seats}"
		end
		# train = train_user_choice
		# if train.class == CargoTrain
		# 	train.each_car_of_train do |car, index| 
		# 		puts "#{index + 1} - Cвободный объем: #{car.free_value} / Занятый объем: #{car.occupied_value}"
		# 	end
		# 	car = train.cars[get_correct_user_choice(train.cars.length, "Выберете вагон") - 1]
		# 	puts "На сколько заполнить вагон?"
		# 	value = gets.chomp.to_i
		# 	raise "Нет столько места" if value > car.free_value
		# 	car.fill_value(value)
		# else
		# 	train.each_car_of_train do |car, index| 
		# 		puts "#{index + 1} - Cвободных мест: #{car.free_seats} / Занятых мест: #{car.occupied_seats}"
		# 	end
		# 	car = train.cars[get_correct_user_choice(train.cars.length, "Выберете вагон") - 1]
		# 	raise "Этот вагон уже полный" if car.free_seats == 0
		# 	car.take_seat
		# end
	end

	def show_trains_on_station(station)
		puts "Список поездов на станции #{station.title}:"
		station.each_train_on_station do |train|
			puts "	#{train.number} (#{train.class}) количество вагонов: #{train.cars.length}"
		end
	end

	def show_cargos_of_train(train)
		puts "Список вагонов поезда \##{train.number}:"
		train.each_car_of_train do |car, index|
			puts "	Вагон №#{index+1} (#{car.class}) - Свободных мест: #{car.free_seats} / Занятых мест: #{car.occupied_seats}" if car.passanger?
			puts "	Вагон №#{index+1} (#{car.class}) - Cвободный объем: #{car.free_value} / Занятый объем: #{car.occupied_value}" if car.cargo?
		end
	end

	def station_user_choice(added_text = "")
		stations_list
		@stations[get_correct_user_choice(@stations.length, "Выберте станцию #{added_text}") - 1]
	end

	def route_user_choice
		routes_list
		@routes[get_correct_user_choice(@routes.length, "Выберете маршрут") - 1]
	end

	def train_user_choice
		trains_list
		@trains[get_correct_user_choice(@trains.length, "Выберете поезд") - 1]
	end

	def stations_list
		@stations.each_with_index {|station, i| puts "#{i + 1} - \"#{station.title}\""}
	end

	def routes_list
		@routes.each_with_index {|route, i| puts "#{i + 1} - \"#{route.route_title}\""}
	end

	def trains_list
		@trains.each_with_index {|train, i| puts "#{i + 1} - #{train.number}"}
	end

	def create_train
		if get_correct_user_choice(2, "Поезд какого типа создать? \n1 - Пассажирский \n2 - Грузовой") == 1
			puts "Введите номер поезда\nДопустимый формат номера \"***-**\""
			@trains << PassangerTrain.new(gets.chomp.upcase)
			puts "Поезд #{@trains.last.number} был успешно создан."
		else
			puts "Введите номер поезда\nДопустимый формат номера \"***-**\""
			@trains << CargoTrain.new(gets.chomp.upcase)
			puts "Поезд #{@trains.last.number} был успешно создан."
		end
	end

	def create_station
		puts "Введите название станции"
		@stations << (Station.new(gets.chomp.capitalize))
		puts "Станция #{@stations.last.title} была успешно создана."
	end

	def create_route(tryed_quantity = 3)
		from = station_user_choice("точки отправления")
		to = station_user_choice("точки прибытия")
		@routes << Route.new(from, to)
		puts "Маршрут был создан \nПуть следования: \"#{@routes.last.route_title}\""
	end

	def add_station_on_route
		route = route_user_choice
		station = station_user_choice
		raise "Эта станция уже есть в маршруте" if route.whole_stations.include?(station)
		route.add_station(station)
		puts "Станция #{station.title} успешно добавлена к маршруту #{route.route_title}!"
	end

	def delete_station_on_route
		route = route_user_choice
		station = station_user_choice
		raise "Нельзя удалить начальную станцию" if station == route.from
		raise "Нельзя удалить конечную станцию" if station == route.to
		raise "Такой станции нет в списке промежуточных станций" if route.intermediate_stations.delete(station).nil?
		puts "Станция #{station.title} успешно удалена из маршрута #{route.route_title}"
	end

	def set_route
		train = train_user_choice
		route = route_user_choice
		train.set_route(route) 
		puts "Маршрут \"#{route.route_title}\" назначен поезду номер #{train.number}"
	end

	def add_car
		train = train_user_choice
		if train.class == CargoTrain
			puts "Введите объем вагона"
			@cargos << CargoCarriage.new(gets.chomp.to_i)
		else
			puts "Введите количество мест"
			@cargos << PassangerCarriage.new(gets.chomp.to_i)
		end
		train.hook_cars(@cargos.last)
		puts "Вагон №#{train.cars.length} успешно добавлен к поезду #{train.number}"
	end
	

	def remove_car
		train = train_user_choice
		train.unhook_cars(train.cars.last)
		puts "Вагон успешно отцеплен"
	end

	def move_train
		train = train_user_choice
		train.go(get_correct_user_choice(2, "1 - Вперед\n2 - Назад"))
		puts "Поезд уехал на станцию \"#{train.location.title}\""
	end

	def exit_app
		return "exit"
	end
end
Main.new.start