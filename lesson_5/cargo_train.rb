class CargoTrain < Train
	initialize_counter
	def initialize(number)
		super
		@type = "cargo"
	end

	def hook_cars(car)
		hook_cars!(car) if train_stopped? && car.cargo? && car.unlocked?
	end

	def unhook_cars(car)
		unhook_cars!(car) if train_stopped? && @cars.include?(car)
	end

	private
	def hook_cars!(car)	# что бы злоумышленник не пристегивал вагоны на ходу и неподходящие вагоны
		@cars << car
		car.lock_car(self)
	end

	def unhook_cars!(car)	# аналогично
		@cars.delete(car)
		car.unlock_car(self)
	end
end