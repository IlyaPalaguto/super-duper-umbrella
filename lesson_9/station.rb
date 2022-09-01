# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation
  attr_reader :title, :trains_on_station

  initialize_counter
  @@stations = []
  TITLE_FORMAT = /^[^\W_[0-9]]+[a-z0-9\s]*$/i.freeze
  validate :title, :presence
  validate :title, :format, TITLE_FORMAT
  validate :title, :type, String

  def initialize(title)
    register_instance
    @title = title
    @trains_on_station = []
    self.validate!
    @@stations << self
  end

  def each_train_on_station(&block)
    trains_on_station.each_with_index { |train, index| block.call(train, index) }
  end

  def self.all
    @@stations
  end

  def self.find(title)
    nil if all.each { |station| return station if station.title.downcase == title.downcase }.empty?
  end

  def send_train(train)
    send_train!(train) if train_on_station?(train)
  end

  def get_train(train)
    get_train!(train) unless train_on_station?(train)
  end

  def passanger_trains_on_station
    trains_on_station.map { |train| train if train.passanger? }.compact
  end

  def cargo_trains_on_station
    trains_on_station.map { |train| train if train.cargo? }.compact
  end

  def train_on_station?(train)
    trains_on_station.include?(train)
  end

  private

  def send_train!(train)
    @trains_on_station.delete(train)
  end

  def get_train!(train)
    @trains_on_station << train
  end
end