module Traits::Controller::Actions::Create
  module InstanceMethods
    def create
      instance_variable_set("@#{singular_name}", resource_class.create(params[singular_name]))
      response_with_options instance_variable_get("@#{singular_name}")
    end
  end
  
  module ClassMethods
    def define_create_with_scope(scope)
      define_method :create do
        _resource = instance_eval(scope).create(params[singular_name])
        instance_variable_set("@#{singular_name}", _resource)
        response_with_options instance_variable_get("@#{singular_name}")
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end