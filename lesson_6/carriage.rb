class Carriage
	include ManufacturerCompany
	attr_reader :to_train, :count
	def initialize
		@to_train = nil
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

	def unlocked?
		false
		true if @to_train.nil?
	end

	protected
	def lock_car!(train)
		@to_train = train 
	end

	def unlock_car!
		@to_train = nil
	end
end
