require_relative 'train'
require_relative 'passanger_train'
require_relative 'cargo_train'
require_relative 'route.rb'
require_relative 'station'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passanger_carriage'
require_relative 'aux_proc_for_main'

action = nil
while action != 0
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
	when 10
		seed
  end
end


