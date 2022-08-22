module InstanceCounter
	def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
		attr_accessor :count_instances	# Я понимаю что это не правильно, но я не понял как создать 
  	def instances 									# переменную класса для наследников модуля, а не для самого модуля InstanceCounter
  		@count_instances
  	end
  	protected
  	def initialize_counter
  		@count_instances = 0
  	end
  end

  module InstanceMethods
  	protected
  	def register_instance
  		self.class.count_instances += 1
  	end
  end
	
end