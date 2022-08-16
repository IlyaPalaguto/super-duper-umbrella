class Train
	attr_accessor :speed
	attr_reader :car_qty, :location, :type

	def initialize(number, type, cars_qty)
		@number = number
		@type = type
		@cars_qty = cars_qty
		@speed = 0
		@location = nil
		@active_route = []
	end

	def hook_cars(qty = 1)
		@cars_qty += qty if @speed == 0
	end

	def unhook_cars(qty = 1)
		@cars_qty -= qty if @speed == 0
	end

	def set_route(route)
		@location.send_train(self) if !@location.nil?								#Если маршрут устанавливается впервые - пропустит этот шаг
		@location = route.from														
		@location.get_train(self)
		@active_route = [route.from]												#Формирование маршрута для поезда
		route.intermediate_stations.each {|station| @active_route << station}
		@active_route << route.to
	end

	def go_next_station
		if !@location.nil? && @location != @active_route.last						#Поезд не поедет дальше если он стоит на последней станции,
			@location.send_train(self)												#или если у него нет маршрута.
			@location = @active_route[(@active_route.find_index(@location) + 1)] 
			@location.get_train(self)
		end
	end

	def go_back_station
		if !@location.nil? && @location != @active_route.first						#Так же он не поедет назад
			@location.send_train(self)
			@location = @active_route[(@active_route.find_index(@location) - 1)] 
			@location.get_train(self)
		end
	end

	def next_station
		@active_route[(@active_route.find_index(@location) + 1)] if !@location.nil? && @location != active_route.last			#Ничего не покажет если
	end 																														#если не установлен
																																#маршрут, или поезд
	def previous_station																										#стоит на последней
		@active_route[(@active_route.find_index(@location) - 1)] if !@location.nil? && @location != @active_route.first			#станции.
	end
end

class Route
	attr_reader :intermediate_stations, :from, :to

	def initialize(from, to)
		@from = from
		@to = to
		@intermediate_stations = []
	end

	def add_station(station)
		@intermediate_stations << station
	end

	def delete_station(station)
		if @intermediate_stations.include?(station)
			@intermediate_stations.delete(station)
		else
			puts "#{station.title} is not defined in route"
		end
	end

	def show_route
		puts "Маршрут '#{@from.title} - #{@to.title}': "
		puts "1. #{@from.title}"
		@intermediate_stations.each_with_index {|station, i| puts "#{i + 2}. #{station.title}"}
		puts "#{@intermediate_stations.length + 2}. #{@to.title}"
	end
end

class Station
	attr_reader :title

	def initialize(title)
		@title = title
		@trains_on_station = []
	end

	def get_train(train)
		@trains_on_station << train
	end

	def send_train(train)
		@trains_on_station.delete(train)
	end

	def trains_on_station(type = 'all')									#В зависимости от входного параметра, указывает поезда находящихся на станции.
		trains_on_station = []											#Если type = "pass" - вернет только пассажирские поезда,
		case type														#Если type = "cargo" - вернет только грузовые поезда.
		when 'pass'														#Если параметр не задан - вернет все позда находящиеся на станции.
			@trains_on_station.each do |train|
				trains_on_station << train if train.type == 'pass'
			end
			return trains_on_station
		when 'cargo'
			@trains_on_station.each do |train|
				trains_on_station << train if train.type == 'cargo'
			end
			return trains_on_station
		else
			@trains_on_station
		end
	end
end


tyumen = Station.new('Tyumen')
moscow = Station.new('Moscow')
new_york = Station.new('New York')
boston = Station.new('Boston')
los_angeles = Station.new('Los Angeles')
las_vegas = Station.new('Las Vegas')

route = Route.new(tyumen, boston)
route2 = Route.new(boston, las_vegas)

route.add_station(moscow)
route.add_station(new_york)

route2.add_station(new_york)
route2.add_station(los_angeles)

train = Train.new(145, 'pass', 3)

train2 = Train.new(777, 'cargo', 15)