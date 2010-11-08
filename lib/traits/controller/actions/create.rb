module Traits::Controller::Actions::Create
  module InstanceMethods
    def create
      instance_variable_set("@#{singular_name}", proxy_klass.create(params[singular_name]))
      response_with_options instance_variable_get("@#{singular_name}")
    end
  end
  
  module ClassMethods

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end