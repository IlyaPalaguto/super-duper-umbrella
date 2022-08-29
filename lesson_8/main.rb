# frozen_string_literal: true

require_relative 'manufacturer_company'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'passanger_train'
require_relative 'cargo_train'
require_relative 'route'
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
      break if user_action == 'exit'
    end
  end

  MENU = [
    { id: 1, title: 'Создать станцию', action: :create_station },
    { id: 2, title: 'Создать поезд', action: :create_train },
    { id: 3, title: 'Создать маршрут или управлять станциями в нем (добавлять, удалять)',
      action: :station_interface },
    { id: 4, title: 'Назначить маршрут поезду', action: :set_route },
    { id: 5, title: 'Добавить вагон к поезду', action: :add_car },
    { id: 6, title: 'Отцепить вагон от поезда', action: :remove_car },
    { id: 7, title: 'Переместить поезд по маршруту вперед или назад', action: :move_train },
    { id: 8, title: 'Посмотреть список поездов на станции', action: :show_trains_on_station },
    { id: 9, title: 'Посмотреть список вагонов поезда', action: :car_list },
    { id: 10, title: 'Посмотреть список станций', action: :stations_list },
    { id: 11, title: 'Занять место или заполнить вагон', action: :car_take_place },
    { id: 12, title: 'Выйти из приложения', action: :exit_app }
  ].freeze

  def show_menu
    puts "\tМеню:"
    MENU.each { |hash| puts "#{hash[:id]} - #{hash[:title]}" }
  end

  def user_action
    user_choice_action = get_correct_user_choice(MENU.length, 'Введите цифру соответствующую действию')
    MENU.map { |h| send(h[:action]) if user_choice_action == h[:id] }.last
  end

  def station_interface
    if get_correct_user_choice(2, "1 - Создать маршрут \n2 - Управлять станциями") == 1
      error_handling { create_route }
    elsif get_correct_user_choice(2, "1 - Добавить станцию \n2 - Удалить станцию") == 1
      error_handling(1) { add_station_on_route }
    else
      error_handling(1) { delete_station_on_route }
    end
  end

  def get_correct_user_choice(answers_quantity, message)
    user_input = nil
    until (1..answers_quantity).cover?(user_input)
      puts message
      user_input = gets.chomp.to_i
    end
    user_input
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
    error_handling(1) do
      car = car_user_choice
      raise 'Вагон полный' if car.free_place.zero?

      if car.instance_of?(CargoCarriage)
        puts 'На сколько заполнить вагон?'
        raise "Нет столько места. Свободный объем: #{car.free_place}" if car.take_place(gets.chomp.to_i).nil?

      else
        car.take_place
      end
      puts "Место успешно занято. Осталось свободного места: #{car.free_place}"
    end
  end

  def show_trains_on_station
    station = station_user_choice
    puts "Список поездов на станции #{station.title}:"
    station.each_train_on_station do |train|
      puts "	#{train.number} (#{train.class}) количество вагонов: #{train.cars.length}"
    end
  end

  def station_user_choice(added_text = '')
    stations_list
    @stations[get_correct_user_choice(@stations.length, "Выберте станцию #{added_text}") - 1]
  end

  def route_user_choice
    routes_list
    @routes[get_correct_user_choice(@routes.length, 'Выберете маршрут') - 1]
  end

  def train_user_choice
    trains_list
    @trains[get_correct_user_choice(@trains.length, 'Выберете поезд') - 1]
  end

  def car_user_choice
    train = car_list
    train.cars[get_correct_user_choice(train.cars.length, 'Выберете вагон') - 1]
  end

  def stations_list
    @stations.each_with_index { |station, i| puts "#{i + 1} - \"#{station.title}\"" }
  end

  def routes_list
    @routes.each_with_index { |route, i| puts "#{i + 1} - \"#{route.route_title}\"" }
  end

  def trains_list
    @trains.each_with_index { |train, i| puts "#{i + 1} - #{train.number}" }
  end

  def car_list
    train = train_user_choice
    train.each_car_of_train do |car, index|
      if car.passanger?
        puts "\tВагон №#{index + 1} (#{car.class}) - Свободных мест: #{car.free_place} / Занятых мест: #{car.used_place}"
      end
      if car.cargo?
        puts "\tВагон №#{index + 1} (#{car.class}) - Cвободный объем: #{car.free_place} / Занятый объем: #{car.used_place}"
      end
    end
    train
  end

  def aux_proc_for_create_train
    error_handling do
      puts "Введите номер поезда\nДопустимый формат номера \"***-**\""
      yield
      puts "Поезд #{@trains.last.number} был успешно создан."
    end
  end

  def create_train
    if get_correct_user_choice(2, "Поезд какого типа создать? \n1 - Пассажирский \n2 - Грузовой") == 1
      aux_proc_for_create_train { @trains << PassangerTrain.new(gets.chomp.upcase) }
    else
      aux_proc_for_create_train { @trains << CargoTrain.new(gets.chomp.upcase) }
    end
  end

  def create_station
    error_handling do
      puts 'Введите название станции'
      @stations << (Station.new(gets.chomp.capitalize))
      puts "Станция #{@stations.last.title} была успешно создана."
    end
  end

  def create_route(_tryed_quantity = 3)
    from = station_user_choice('точки отправления')
    to = station_user_choice('точки прибытия')
    @routes << Route.new(from, to)
    puts "Маршрут был создан \nПуть следования: \"#{@routes.last.route_title}\""
  end

  def add_station_on_route
    route = route_user_choice
    station = station_user_choice
    raise 'Эта станция уже есть в маршруте' if route.whole_stations.include?(station)

    route.add_station(station)
    puts "Станция #{station.title} успешно добавлена к маршруту #{route.route_title}!"
  end

  def delete_station_on_route
    route = route_user_choice
    station = station_user_choice
    raise 'Нельзя удалить начальную станцию' if station == route.from
    raise 'Нельзя удалить конечную станцию' if station == route.to
    raise 'Такой станции нет в списке промежуточных станций' if route.intermediate_stations.delete(station).nil?

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
    if train.instance_of?(CargoTrain)
      puts 'Введите объем вагона'
      @cargos << CargoCarriage.new(gets.chomp.to_i)
    else
      puts 'Введите количество мест'
      @cargos << PassangerCarriage.new(gets.chomp.to_i)
    end
    train.hook_cars(@cargos.last)
    puts "Вагон №#{train.cars.length} успешно добавлен к поезду #{train.number}"
  end

  def remove_car
    train = train_user_choice
    train.unhook_cars(train.cars.last)
    puts 'Вагон успешно отцеплен'
  end

  def move_train
    error_handling(1) do
      train = train_user_choice
      raise 'У поезда нет назначенного маршрута!' if train.active_route.nil?
      if train.go(get_correct_user_choice(2, "1 - Вперед\n2 - Назад")).nil?
        raise 'Поезд не может ехать в этом направлениии, так как он стоит на крайней станции'

      end

      puts "Поезд уехал на станцию \"#{train.location.title}\""
    end
  end

  def exit_app
    'exit'
  end
end
Main.new.start
