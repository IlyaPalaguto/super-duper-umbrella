class Train
	include ManufacturerCompany
	include InstanceCounter
	attr_accessor :speed
	attr_reader :location, :type, :number, :active_route, :cars
	NUMBER_FORMAT = /^[0-9a-zа-я]{3}-?[a-zа-я0-9]{2}$/i

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
		validate!
		@@trains << self
	end
	
	def valid?
		validate!
		true
	rescue
		false
	end

	def self.all
		@@trains
	end
	
	def self.find(number)
		nil if (self.all.each {|train| return train if train.number == number}).empty?
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
	
	def validate!
		raise "Неправильный формат номера" if number !~ NUMBER_FORMAT
	end
	
	def current_index_station
		@active_route.whole_stations.find_index(@location)
	end
			
	def send_train_on_first_station!(route)
		@location.send_train(self) if @location
		@location = route.from
		@location.get_train(self)
	end

	def set_route!(route)
		@active_route = route
	end
end
