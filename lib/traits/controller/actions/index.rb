module Traits::Controller::Actions::Index
  
  module InstanceMethods
    def index
      collection = proxy_klass.respond_to?(:search) ? proxy_klass.search(params) : proxy_klass.scoped
      collection = collection.paginate(:page => params[:page] || 1) if (defined? _custom_options && _custom_options[:paginated])
      instance_variable_set("@#{singular_name.pluralize}", collection)
      response_with_options collection
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
  
end