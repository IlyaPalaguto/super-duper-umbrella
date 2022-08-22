class Station
	include InstanceCounter
	initialize_counter
	@@all_station = []
	attr_reader :title

	def initialize(title)
		register_instance
		@title = title
		@trains_on_station = []
		@@all_station << self
	end

	def self.all
		@@all_station
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

	def send_train!(train)
		@trains_on_station.delete(train)
	end

	def get_train!(train)
		@trains_on_station << train
	end
end