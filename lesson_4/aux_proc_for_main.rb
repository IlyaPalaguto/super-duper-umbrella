def routes_list
	Route.routes_array.each_with_index {|route, i| puts "#{i + 1} - \"#{route.route_title}\""}
end

def trains_list
	Train.trains_array.each_with_index {|train, i| puts "#{i + 1} - #{train.number}"}
end

def stations_list
	Station.stations_array.each_with_index {|station, i| puts "#{i + 1} - \"#{station.title}\""}
end

def current_station(added_text = "")
	puts "Выберте станцию " + added_text
	stations_list
	Station.stations_array[gets.chomp.to_i - 1]
end

def current_route
	puts "Выберете маршрут"
	routes_list
	Route.routes_array[gets.chomp.to_i - 1]
end

def current_train
	puts "Выберете поезд"
	trains_list
	Train.trains_array[gets.chomp.to_i - 1]
end

def create_station
	puts "Введите название станции"
	station = Station.new(gets.chomp.capitalize)
	puts "Станция #{station.title} была успешно создана."
end

def create_route
	from = current_station("точки отправления")
	puts "Станция #{from.title} - теперь начальная станция маршрута"

	to = nil
	until to
		to = current_station("точки прибытия")
		if to == from
			puts "Начальная и конечная станции должны отличаться"
			to = nil
		else
			puts "Станция #{to.title} - теперь конечная станция маршрута"
		end
	end
	route = Route.new(from, to)
	puts "Маршрут был создан \nПуть следования: \"#{route.route_title}\""
end

def add_station_on_route
	route = current_route
	station = current_station
	if route.whole_stations.include?(station)
		puts "Эта станция уже есть в маршруте"
	else
		route.add_station(station)
		puts "Станция #{station.title} успешно добавлена к маршруту #{route.route_title}!"
	end
end

def delete_station_on_route
	route = current_route
	puts "Какую станцию удалить из маршрута?"
	route.intermediate_stations.each_with_index {|station, i| puts "#{i + 1} - #{station.title}"}
	user_choice = gets.chomp.to_i - 1
	what_delete = route.intermediate_stations.delete(route.intermediate_stations[user_choice])
	puts "Станция #{what_delete.title} успешно удалена из маршрута #{route.route_title}"
end

def create_train
	puts "Введите номер поезда"
	number = gets.chomp
	puts "Поезд какого типа создать? \n1 - Пассажирский \n2 - Грузовой"
	if gets.chomp.to_i == 1
		train = PassangerTrain.new(number)
	else
		train = CargoTrain.new(number)
	end
	puts "Поезд с номером #{train.number} был успешно создан"
end

def set_route
	train = current_train
	route = current_route
	train.set_route(route)
	puts "Маршрут \"#{route.route_title}\" назначен поезду номер #{train.number}"
end

def move_train
	puts "1 - Вперед\n2 - Назад"
	user_choice = gets.chomp.to_i 
	train = current_train
	train.go(user_choice)
	puts "Поезд уехал на станцию \"#{train.location.title}\""
end

def add_car
	train = current_train
	if train.class == CargoCarriage
		car = CargoCarriage.new
	else
		car = PassangerCarriage.new
	end
	train.hook_cars(car)
	puts "Вагон №#{car.count} успешно добавлен к поезду #{train.number}"
	puts "Количество вагонов - #{train.cars.length}"
end

def remove_car
	train = current_train
	train.unhook_cars(train.cars.last)
	puts "Вагон успешно отцеплен"
end

def trains_list_on_station
	station = current_station
	puts "Список поездов на станции \"#{station.title}\":"
	station.trains_on_station.each_with_index {|train, i| puts "#{i + 1} - #{train.number}"}
	puts "(пусто)" if station.trains_on_station.empty?
end

def seed
	PassangerTrain.new('P140ET').set_route(Route.new(Station.new('Moscow'), Station.new('New york')))
	PassangerTrain.new('H777TT').set_route(Route.new(Station.new('Los angeles'), Station.new('Las vegas')))
	CargoTrain.new('A072TO').set_route(Route.new(Station.new('Tyumen'), Station.new('Boston')))
end