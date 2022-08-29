# frozen_string_literal: true

class Route
  include InstanceCounter
  attr_reader :intermediate_stations, :from, :to, :title

  initialize_counter
  def initialize(from, to)
    register_instance
    @from = from
    @to = to
    @intermediate_stations = []
    validate!
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    add_station!(station) if off_route?(station)
  end

  def delete_station(station)
    delete_station!(station) if on_route?(station)
  end

  def route_title
    "#{from.title} - #{to.title}"
  end

  def whole_stations
    whole_stations = [@from]
    intermediate_stations.each { |s| whole_stations << s }
    whole_stations << @to
  end

  def on_route?(station)
    intermediate_stations.include?(station)
  end

  def off_route?(_station)
    !on_route?
  end

  private

  def validate!
    raise 'Начальная и конечная станции должны отличаться' if @from == @to
    raise "Станции \"#{from.title}\" не существует!" unless Station.all.include?(@from)
    raise "Станции \"#{to.title}\" не существует!" unless Station.all.include?(@to)
  end

  def add_station!(station)
    @intermediate_stations << station
  end

  def delete_station!(station)
    @intermediate_stations.delete(station)
  end
end
