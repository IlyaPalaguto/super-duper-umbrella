class Station
	include InstanceCounter
	attr_reader :title, :trains_on_station
	initialize_counter
	@@stations = []
	TITLE_FORMAT = /^[^\W_[0-9]]+[a-z0-9\s]*$/i

	def initialize(title)
		register_instance
		@title = title
		@trains_on_station = []
		validate!
		@@stations << self
	end

	def each_train_on_station(&block)
		@trains_on_station.each_with_index {|train, index| block.call(train, index)}
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
	
	def passanger_trains_on_station
		@trains_on_station.map {|train| train if passanger?(train)}.compact
	end
	
	def cargo_trains_on_station
		@trains_on_station.map {|train| train if cargo?(train)}.compact
	end
	
	def passanger?(train)
		false
		true if train.class == PassangerTrain
	end
	
	def cargo?(train)
		false
		true if train.class == CargoTrain
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



tyumen = Station.new('Tyumen')
moscow = Station.new('Moscow')
route = Route.new(tyumen, moscow)
train = PassangerTrain.new('asd-12')
train2 = PassangerTrain.new('asd-13')
train.set_route(route)
train2.set_route(route)
