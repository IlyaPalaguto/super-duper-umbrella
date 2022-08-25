class PassangerCarriage < Carriage
  attr_reader :free_seats, :occupied_seats
  def initialize(seats = 50)
    super
    @seats = seats
    @occupied_seats = 0
    @free_seats = seats
  end

  def take_seat
		take_seat! if on_station?
	end

  private

	def take_seat!
		@free_seats -= 1
		@occupied_seats += 1
	end
end