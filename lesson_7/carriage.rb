class Carriage
	include ManufacturerCompany
	attr_reader :train_connected, :count, :total_place, :used_place
	def initialize(total_place)
		@train_connected = nil
		@total_place = total_place
		@used_place = 0
	end

	def free_place
		total_place - used_place
	end

	def take_place
		raise "Not implemented"
	end

	def lock_car(train)
		lock_car!(train) if train.hooked?(self)
	end

	def unlock_car(train)
		unlock_car! if !train.hooked?(self)
	end

	def passanger?
		self.class == PassangerCarriage
	end

	def cargo?
		self.class == CargoCarriage
	end

	def locked?
		!train_connected.nil?
	end

	def unlocked?
		train_connected.nil?
	end

	protected
	def lock_car!(train)
		@train_connected = train 
	end

	def unlock_car!
		@train_connected = nil
	end
end
