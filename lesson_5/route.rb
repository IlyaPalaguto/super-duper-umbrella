class Route
	include InstanceCounter
	attr_reader :intermediate_stations, :from, :to, :title
	initialize_counter
	def initialize(from, to)
		register_instance
		@from = from
		@to = to
		@intermediate_stations = []
	end

	def add_station(station)
		add_station!(station) if off_route?(station)
	end

	def delete_station(station)
		delete_station!(station) if on_route?(station)
	end

	def show_route
		puts "Список станций по маршруту #{route_title}:"
		puts list_stations_titles(whole_stations)
	end

	def route_title
		"#{@from.title} - #{@to.title}"
	end

	def whole_stations
		whole_stations = [@from]
		@intermediate_stations.each {|s| whole_stations << s}
		whole_stations << to
	end

	def list_stations_titles(stations)
		stations.each_with_index {|s, i| puts "#{i + 1}. #{s.title}"}
		return nil
	end

	def off_route?(station)
		true if !@intermediate_stations.include?(station)
	end

	def on_route?(station)
		true if @intermediate_stations.include?(station)
	end

	private
	def add_station!(station)
		@intermediate_stations << station
	end

	def delete_station!(station)
		@intermediate_stations.delete(station)
	end
end