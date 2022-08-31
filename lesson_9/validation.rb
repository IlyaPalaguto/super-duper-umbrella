module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end
  
  module ClassMethods
    def validates
      @validates ||= []
    end
    
    def validate(*args)
      define_method("#{args[0]}_#{args[1]}") do
        var_name = instance_variable_get("@#{args[0]}")
        if args[1] == :presence
          raise 'Значение не должно быть пустым!' if var_name.nil? || var_name.to_s.empty?
        elsif args[1] == :format
          regexp = args[2]
          raise 'Неправильный формат!' if var_name !~ regexp
        elsif args[1] == :type
          type = args[2]
          raise 'Неправильный тип!' if var_name.class != type
        end
      end
      validates << "#{args[0]}_#{args[1]}".to_sym
    end
  end

  module InstanceMethods
    def validate!
      self.class.validates.each {|method| send(method)}
    end
    
    def valid?
      validate!
      true
      rescue RuntimeError
        false
      end
  end

end
