module Traits::Controller::Actions::Edit
  module InstanceMethods
    def edit
      resource = instance_variable_get("@#{singular_name}")
      respond_with resource
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end