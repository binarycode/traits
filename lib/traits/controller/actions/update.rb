module Traits::Controller::Actions::Update
  module InstanceMethods
    def update
      resource = instance_variable_get("@#{singular_name}").update_attributes(params[singular_name])
      response_with_options resource
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end