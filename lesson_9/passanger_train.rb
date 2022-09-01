# frozen_string_literal: true

class PassangerTrain < Train
  attr_reader :seats

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String
  initialize_counter
  def initialize(number)
    super
    @type = 'passanger'
  end

  def hook_cars(car)
    hook_cars!(car) if train_stopped? && car.passanger? && car.unlocked?
  end

  def unhook_cars(car)
    unhook_cars!(car) if train_stopped? && @cars.include?(car)
  end

  private

  def hook_cars!(car)
    @cars << car
    car.lock_car(self)
  end

  def unhook_cars!(car)
    @cars.delete(car)
    car.unlock_car(self)
  end
end
