# frozen_string_literal: true

class PassangerCarriage < Carriage
  def take_place
    @used_place += 1 if free_place.positive?
  end
end
