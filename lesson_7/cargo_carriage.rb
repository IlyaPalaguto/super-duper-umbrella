class CargoCarriage < Carriage
  
  def initialize(total_place)
    super
  end

  def take_place(amount)
		@used_place += amount if amount < free_place 
	end

end