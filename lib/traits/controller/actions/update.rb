module Traits::Controller::Actions::Update
  module InstanceMethods
    def update
      instance_variable_get("@#{singular_name}").update_attributes(params[singular_name])
      response_with_options instance_variable_get("@#{singular_name}")
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end