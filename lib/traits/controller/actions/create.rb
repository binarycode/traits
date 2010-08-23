module Traits::Controller::Actions::Create
  module InstanceMethods
    def create
      instance_variable_set("@#{singular_name}", resource_class.create(params[singular_name]))
      respond_with instance_variable_get("@#{singular_name}")
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end