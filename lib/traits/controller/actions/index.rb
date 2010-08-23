module Traits::Controller::Actions::Index
  
  module InstanceMethods
    def index
      respond_with resource_class.all
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
  
end