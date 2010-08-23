module Traits::Controller::Actions::Index
  
  module InstanceMethods
    def index
      collection = params[:filter] ? resource_class.search(params) : resource_class.all
      response_with_options collection
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
  
end