# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*variables)
      variables.each do |variable|
        raise "Аргумент должен содержать символ!" unless variable.is_a?(Symbol)

        define_method(variable) do
          instance_variable_get("@#{variable}")
        end

        define_method("#{variable}=") do |value|
          self.instance_eval "@#{variable}_history ||= []"
          instance_variable_set("@#{variable}", value)
          self.instance_eval "@#{variable}_history.send(:<<, { value: value, date: Time.now })"
        end
      end
    end

    def strong_attr_accessor(variable, variable_class)

      define_method(variable) do
        instance_variable_get("@#{variable}")
      end
      
      define_method("#{variable}=") do |value|
        if value.class == variable_class
          instance_variable_set("@#{variable}", value)
        else
          raise "Тип присваемого значения не подходит"

        end
      end
    end
  end

  module InstanceMethods
    def method_missing(name)
      if name =~ /_history$/
        name.to_sym
        instance_variable_get("@#{name}")
      else
        raise NoMethodError.new("Такого метода нет")
      end
    end
  end
end