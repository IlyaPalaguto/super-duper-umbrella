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

	MENU = [
		{id: 1, title: 'Создать станцию', action: [:error_handling, :create_station, 3]},
		{id: 2, title: 'Создать поезд', action: [:error_handling, :create_train, 3]},
		{id: 3, title: 'Создать маршрут или управлять станциями в нем (добавлять, удалять)', action: [:station_interface]},
		{id: 4, title: 'Назначить маршрут поезду', action: [:set_route]},
		{id: 5, title: 'Добавить вагон к поезду', action: [:add_car]},
		{id: 6, title: 'Отцепить вагон от поезда', action: [:remove_car]},
		{id: 7, title: 'Переместить поезд по маршруту вперед или назад', action: [:error_handling, :move_train, 1]},
		{id: 8, title: 'Посмотреть список поездов на станции', action: [:show_trains_on_station]},
		{id: 9, title: 'Посмотреть список вагонов поезда', action: [:car_list]},
		{id: 10, title: 'Посмотреть список станций', action: [:stations_list]},
		{id: 11, title: 'Занять место или заполнить вагон', action: [:error_handling, :car_take_place, 1]},
		{id: 0, title: 'Выйти из приложения', action: [:exit_app]}
	]
  def show_menu
    MENU.each {|hash| puts "#{hash[:id]} - #{hash[:title]}"}
  end
	
	def get_user_action
		puts "Введите цифру соответствующую действию"
    user_choice_action = gets.chomp.to_i
		MENU.each do |h|
			action = []
			action = h[:action] if user_choice_action == h[:id]
			if action.include?(:error_handling)
				send(action[0], (action[2])){send(action[1])}
			elsif !action.empty?
				return 'exit' if send(action[0]) == 'exit'
			end
		end
	end
	
	def station_interface
		if get_correct_user_choice(2, "1 - Создать маршрут \n2 - Управлять станциями") == 1
			error_handling { create_route }
		else
			if get_correct_user_choice(2, "1 - Добавить станцию \n2 - Удалить станцию") == 1
				error_handling(1) {add_station_on_route}
			else
				error_handling(1) {delete_station_on_route}
			end
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

	def car_take_place
		car = car_user_choice
		raise "Вагон полный" if car.free_place == 0
		if car.class == CargoCarriage
			puts "На сколько заполнить вагон?"
			amount = gets.chomp.to_i
			raise "Нет столько места. Свободный объем: #{car.free_place}" if car.take_place(amount).nil?
			puts "Вагон успешно заполнен. Осталось свободного объема: #{car.free_place}"
		else 
			car.take_place
			puts "Место успешно занято. Осталось свободных мест: #{car.free_place}"
		end
	end

	def show_trains_on_station
		station = station_user_choice
		puts "Список поездов на станции #{station.title}:"
		station.each_train_on_station do |train|
			puts "	#{train.number} (#{train.class}) количество вагонов: #{train.cars.length}"
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

	def car_user_choice
		train = car_list
		train.cars[get_correct_user_choice(train.cars.length, "Выберете вагон") - 1]
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

	def car_list
		train = train_user_choice
		train.each_car_of_train do |car, index|
			puts "	Вагон №#{index+1} (#{car.class}) - Свободных мест: #{car.free_place} / Занятых мест: #{car.used_place}" if car.passanger?
			puts "	Вагон №#{index+1} (#{car.class}) - Cвободный объем: #{car.free_place} / Занятый объем: #{car.used_place}" if car.cargo?
		end
		return train
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
		raise "У поезда нет назначенного маршрута!" if train.active_route.nil?
		raise "Поезд не может ехать в этом направлениии, так как он стоит на крайней станции" if train.go(get_correct_user_choice(2, "1 - Вперед\n2 - Назад")).nil?
		puts "Поезд уехал на станцию \"#{train.location.title}\""
	end

	def exit_app
		return "exit"
	end
end
Main.new.start