module Traits::Controller::Actions::Index
  
  module InstanceMethods
    def index
      collection = params[:filter] ? collection_or_klass.search(params) : collection_or_klass.all
      instance_variable_set("@#{singular_name.pluralize}", collection)
      response_with_options collection
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
  
end