class PassangerCarriage < Carriage

  def initialize(total_place)
    super
  end

  def take_place
		@used_place += 1 if free_place > 0
	end

end