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
        
        def collection_scope named_scope, options = {}
          class_eval do
             class_variable_set("@@collection_scope", named_scope)
             class_variable_set("@@collection_scope_options", options)
          end
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
        
        def collection_or_klass
          except = (defined? @@collection_scope_options) &&  @@collection_scope_options[:except]
          return resource_class if except && Array.wrap(except).include?(action_name.to_sym)
          (defined? @@collection_scope) ? instance_eval(@@collection_scope) : resource_class
        end
        
        def response_with_options(resource)
           serialize_options  = {}
           begin
             serialize_options = resource_class.const_get(:SerializeOptions)
           rescue
           end
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