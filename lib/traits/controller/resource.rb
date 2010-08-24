module Traits
  module Controller
    module Resource
      module ClassMethods
        def self.extended(reciever)
          reciever.before_filter "find_#{reciever.controller_name.singularize}"
        end
        
        def singular_name
          controller_name.singularize
        end
      end
      
      module InstanceMethods
        def self.included(receiver)
          receiver.send(:define_method, "find_#{receiver.singular_name}") do
            instance_variable_set("@#{singular_name}", resource_class.find(params[:id])) if params[:id]
          end
        end
        
        def singular_name
           controller_name.singularize
         end
        
        def resource_class
          singular_name.classify.constantize
        end
        
        def response_with_options(resource)
          serialize_options = resource_class.constants.include?("SerializeOptions") ? 
                                                    resource_class::SerializeOptions  : {}
          respond_with resource, serialize_options
        end
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end