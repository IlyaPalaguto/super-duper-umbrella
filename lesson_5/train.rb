class Train
	include ManufacturerCompany
	include InstanceCounter
	attr_accessor :speed
	attr_reader :location, :type, :number, :active_route, :cars

	@@trains = []
	initialize_counter

	def initialize(number)
		register_instance
		@number = number
		@cars = []
		@speed = 0
		@location = nil
		@active_route = nil
		@type = nil
		@@trains << self
	end

	def self.find(number)
		nil if (@@trains.each {|train| return train if train.number == number}).empty?
	end

	def set_route(route)
		set_route!(route)
		send_train_on_first_station!(route)
	end

	def go(where)
		go_next_station! if where == 1
		go_back_station! if where == 2
	end

	def go_next_station!
		if @location && !on_last_station?
			@location.send_train(self)
			@location = next_station
			@location.get_train(self)
		end
	end
							# Не знаю как сократить эти два метода что бы применить правило DRY :(((
	def go_back_station!
		if @location && !on_first_station?
			@location.send_train(self)
			@location = previous_station
			@location.get_train(self)
		end
	end

	def next_station
		@active_route.whole_stations[current_index_station + 1] if @location && !on_last_station?
	end
								# Не знаю как сократить эти два метода что бы применить правило DRY :(((
	def previous_station
		@active_route.whole_stations[current_index_station - 1] if @location && !on_first_station?
	end

	def on_first_station?
		true if @location == @active_route.from
	end

	def on_last_station?
		true if @location == @active_route.to
	end

	def hooked?(car)
		true if @cars.include?(car)
	end

	def train_stopped?
		true if @speed == 0
	end

	protected

	def current_index_station 																	# т.к. этот метод не вызывается вне класса, но в целом ничего страшного не проийзойдет если он будет в интерфейсе класса
		@active_route.whole_stations.find_index(@location)				# я сомневаюсь что он нужен вообще
	end

	def send_train_on_first_station!(route) 										# т.к. этот метод не вызывается вне класса, и он не должен попасть в паблик потому что пользователь
		@location.send_train(self) if @location										# в обход UI через консоль может отправить поезд на станцию вне маршрута.
		@location = route.from
		@location.get_train(self)
	end

	def set_route!(route)																				# т.к. этот метод не вызывается вне класса, и не может находится в паблик потому что можно будет 
		@active_route = route  																		# поменять маршрут, а поезд останется на той же локации
	end
end
