class Station
	include InstanceCounter
	attr_reader :title
	initialize_counter
	@@stations = []
	TITLE_FORMAT = /^[^\W_[0-9]]+[a-z0-9\s]*$/i

	def initialize(title)
		register_instance
		@title = title
		@trains_on_station = []
		@@stations << self
		validate!
	end

	def valid?
		validate!
		true
	rescue
		false
	end
	
	def self.all
		@@stations
	end
	
	def self.find(title)
		nil if self.all.each {|station| return station if station.title.downcase == title.downcase}.empty?
	end
	
	def send_train(train)
		send_train!(train) if train_on_station?(train)
	end
	
	def get_train(train)
		get_train!(train) if !train_on_station?(train)
	end
	
	def trains_on_station(type = 'all')
		if passanger?(type)
			passanger_trains(@trains_on_station)
		elsif cargo?(type)
			cargo_trains(@trains_on_station)
		else
			@trains_on_station
		end
	end
	
	def passanger_trains(trains)
		trains.map {|t| t if passanger?(t.type)}.compact
	end
	
	def cargo_trains(trains)
		trains.map {|t| t if cargo?(t.type)}.compact
	end
	
	def passanger?(type)
		true if type == 'passanger'
	end
	
	def cargo?(type)
		true if type == 'cargo'
	end
	
	def train_on_station?(train)
		@trains_on_station.include?(train)
	end
	
	private
	
	def validate!
		raise "Название должно начинаться с буквы и не может содержать символов" if @title !~ TITLE_FORMAT
	end

	def send_train!(train)
		@trains_on_station.delete(train)
	end

	def get_train!(train)
		@trains_on_station << train
	end
end