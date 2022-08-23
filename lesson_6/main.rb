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
    3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
    4 - Назначить маршрут поезду
    5 - Добавлить вагон к поезду
    6 - Отцеплить вагон от поезда
    7 - Переместить поезд по маршруту вперед или назад
    8 - Посмотреть список поездов на станции
    9 - Посмотреть список станций
    0 - Выйти из приложения"
  end

	
	
	
  def get_user_action
    puts "Введите цифру соответствующую действию"
    action = gets.chomp.to_i
    case action
    when 1
			create_station
    when 2
      create_train
    when 3
      user_input = 0
      until (1..2).cover?(user_input)
        puts "1 - Создать маршрут \n2 - Управлять станциями"
        user_input = gets.chomp.to_i
      end
      if user_input == 1
        create_route
      else
        user_input = 0
        until (1..2).cover?(user_input)
          puts "1 - Добавить станцию \n2 - Удалить станцию"
          user_input = gets.chomp.to_i
        end
        if user_input == 1
          add_station_on_route
        elsif user_input == 2
          delete_station_on_route
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
      trains_list_on_station
    when 9 
      puts "Список станций:"
      stations_list
    when 0
      exit_app
    end
  end
	
	def station_user_choice(added_text = "")
		puts "Выберте станцию " + added_text
		stations_list
		@stations[gets.chomp.to_i - 1]
	end

	def route_user_choice
		puts "Выберете маршрут"
		routes_list
		@routes[gets.chomp.to_i - 1]
	end

	def train_user_choice
		puts "Выберете поезд"
		trains_list
		@trains[gets.chomp.to_i - 1]
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

	def create_train(tryed_quantity = 3)
		puts "Поезд какого типа создать? \n1 - Пассажирский \n2 - Грузовой"
		if gets.chomp.to_i == 1
			puts "Введите номер поезда\nДопустимый формат номера \"***-**\""
			@trains << PassangerTrain.new(gets.chomp.upcase)
		else
			puts "Введите номер поезда\nДопустимый формат номера \"***-**\""
			@trains << CargoTrain.new(gets.chomp.upcase)
		end
		puts "Поезд с номером #{@trains.last.number} был успешно создан"
	rescue RuntimeError => e
		tryed_quantity -= 1
		puts "Ошибка: #{e.message}"
		puts "Попробуйте еще раз\n(осталось попыток: #{3-tryed_quantity})" if tryed_quantity != 0
		retry if tryed_quantity != 0
	end

	def create_station(tryed_quantity = 3)
		puts "Введите название станции"
		@stations << (Station.new(gets.chomp.capitalize))
		puts "Станция #{@stations.last.title} была успешно создана."
	rescue RuntimeError => e
		tryed_quantity -= 1
		puts "Ошибка: #{e.message}"
		puts "Попробуйте еще раз\n(осталось попыток: #{tryed_quantity})" if tryed_quantity != 0
		retry if tryed_quantity != 0
	end

	def create_route(tryed_quantity = 3)
		from = station_user_choice("точки отправления")
		to = station_user_choice("точки прибытия")
		@routes << Route.new(from, to)
		puts "Маршрут был создан \nПуть следования: \"#{@routes.last.route_title}\""
	rescue RuntimeError => e
		tryed_quantity -= 1
		puts "Ошибка: #{e.message}"
		puts "Попробуйте еще раз\n(осталось попыток: #{tryed_quantity})" if tryed_quantity != 0
		retry if tryed_quantity != 0
	end

	def add_station_on_route
		route = route_user_choice
		station = station_user_choice
		if route.whole_stations.include?(station)
			puts "Эта станция уже есть в маршруте"
		else
			route.add_station(station)
			puts "Станция #{station.title} успешно добавлена к маршруту #{route.route_title}!"
		end
	end

	def delete_station_on_route
		route = route_user_choice
		puts "Какую станцию удалить из маршрута?"
		route.intermediate_stations.each_with_index {|station, i| puts "#{i + 1} - #{station.title}"}
		user_choice = gets.chomp.to_i - 1
		what_deleted = route.intermediate_stations.delete(route.intermediate_stations[user_choice])
		puts "Станция #{what_deleted.title} успешно удалена из маршрута #{route.route_title}"
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
			@cargos << CargoCarriage.new
		else
			@cargos << PassangerCarriage.new
		end
		train.hook_cars(@cargos.last)
		puts "Вагон №#{@cargos.length} успешно добавлен к поезду #{train.number}"
		puts "Количество вагонов - #{train.cars.length}"
	end

	def remove_car
		train = train_user_choice
		train.unhook_cars(train.cars.last)
		puts "Вагон успешно отцеплен"
	end

	def move_train
		puts "1 - Вперед\n2 - Назад"
		user_choice = gets.chomp.to_i 
		train = train_user_choice
		train.go(user_choice)
		puts "Поезд уехал на станцию \"#{train.location.title}\""
	end

	def trains_list_on_station
		station = station_user_choice
		puts "Список поездов на станции \"#{station.title}\":"
		station.trains_on_station.each_with_index {|train, i| puts "#{i + 1} - #{train.number}"}
		puts "(пусто)" if station.trains_on_station.empty?
	end

	def exit_app
		return "exit"
	end
end
Main.new.start