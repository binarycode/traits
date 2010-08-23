module Traits::Controller::Actions::Destroy
  module InstanceMethods
    def destroy
      resource = instance_variable_get("@#{singular_name}").destroy
      respond_with resource, :location => send("#{controller_name}_path")
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end