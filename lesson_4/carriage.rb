class Carriage
	attr_reader :to_train, :count
	@@carriage_array = [nil]

	def initialize
		@count = @@carriage_array.length
		@to_train = nil
		@@carriage_array << self
	end

	def self.carriage_array
		@@carriage_array
	end

	def lock_car(train)
		lock_car!(train) if train.hooked?(self)
	end

	def unlock_car(train)
		unlock_car! if !train.hooked?(self)
	end

	def passanger?
		true if self.class == PassangerCarriage
	end

	def cargo?
		true if self.class == CargoCarriage
	end

	def unlocked?
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
