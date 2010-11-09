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
        
        def set_scope(scope, options = {})
          class_eval do
            attr_accessor_with_default :collection_scope, { :scope => scope, :condition => options }
          end
        end
        
        def set_options(options = {})
          class_eval do
            attr_accessor_with_default :_custom_options, options
          end
        end
        
        def define_actions(*args)
          args.map {|v| v.to_s.classify }.each {|v| self.send(:include, "Traits::Controller::Actions::#{v}".constantize) }
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
        
        def proxy_klass
          return resource_class if !defined?(collection_scope) 
          
          action  = action_name.to_sym
          only    = Array.wrap(collection_scope[:condition][:only])
          except  = Array.wrap(collection_scope[:condition][:except])
          
          return resource_class if except.include?(action)
                  
          return instance_eval(collection_scope[:scope]) if collection_scope[:condition].blank? ||
                    (only.include?(action) && !except.include?(action))
                    
          return resource_class
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