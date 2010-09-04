module Traits::Controller::Actions::New
  module InstanceMethods
    def new
      resource = instance_variable_set("@#{singular_name}", resource_class.new)
      respond_with resource
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end