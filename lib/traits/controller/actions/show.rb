module Traits::Controller::Actions::Show
  module InstanceMethods
    def show
      response_with_options instance_variable_get("@#{singular_name}")
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end