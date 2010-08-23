module Traits::Controller::Actions::Show
  module InstanceMethods
    def show
      respond_with instance_variable_get("@#{singular_name}")
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end