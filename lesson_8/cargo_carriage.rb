# frozen_string_literal: true

class CargoCarriage < Carriage
  def take_place(amount)
    @used_place += amount if amount < free_place
  end
end
