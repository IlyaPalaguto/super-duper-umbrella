class Carriage
	include ManufacturerCompany
	attr_reader :train_connected, :count
	def initialize(seats = 0, value = 0)
		@train_connected = nil
	end

	def lock_car(train)
		lock_car!(train) if train.hooked?(self)
	end

	def unlock_car(train)
		unlock_car! if !train.hooked?(self)
	end

	def passanger?
		false
		true if self.class == PassangerCarriage
	end

	def cargo?
		false
		true if self.class == CargoCarriage
	end

	def on_station?
		false
		true if locked? && @train_connected.location
	end

	def locked?
		false
		true if @train_connected
	end

	def unlocked?
		false
		true if @train_connected.nil?
	end

	protected
	def lock_car!(train)
		@train_connected = train 
	end

	def unlock_car!
		@train_connected = nil
	end
end
