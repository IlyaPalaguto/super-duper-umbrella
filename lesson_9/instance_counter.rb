# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :count_instances

    def instances
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
