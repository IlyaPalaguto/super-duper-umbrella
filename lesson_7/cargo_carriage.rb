class CargoCarriage < Carriage
  attr_reader :free_value, :occupied_value
  def initialize(value = 50)
    super
    @value = value
    @occupied_value = 0
    @free_value = value
  end

  def fill_value(val)
		fill_value!(val) if on_station?
	end

  private

	def fill_value!(val)
		@free_value -= val
		@occupied_value += val
	end
end