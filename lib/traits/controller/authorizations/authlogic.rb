module Traits::Controller::Authorization::Authlogic
    module ClassMethods
      def self.extended(reciever)
        reciever.helper_method :current_session, :current_user
      end
      
      def add_authorization_interfaces(*args)
        args.each do |v|
          helper_method "current_#{v}_session", "current_#{v}"
          define_method "current_#{v}_session" do
            ivar_name = "@current_#{v}_session"
            if instance_variable_defined?(ivar_name)
              return instance_variable_get(ivar_name)
            end
            instance_variable_set(ivar_name, "#{v.to_s.classify}Session".constantize.find)
          end
          
          define_method "current_#{v}" do
            ivar_name = "@current_#{v}"
            if instance_variable_defined?(ivar_name)
              return instance_variable_get(ivar_name)
            end
            ivar_session = send("current_#{v}_session")
            instance_variable_set(ivar_name, ivar_session && ivar_session.record)
          end
          
          define_method "#{v}_authenticate" do
            unless send("current_#{v}")
              store_location
              #TODO its should be configurable, may be
              redirect_to send("#{v}_login_path"), :notice => "You must be logged in to access this page"
              return false
            end
          end
        end
      end
    end
    
    module InstanceMethods
      private
         def current_session
           return @current_session if defined?(@current_session)
           @current_session = UserSession.find
         end

         def current_user
           return @current_user if defined?(@current_user)
           @current_user = current_session && current_session.record
         end

         def authenticate
           unless current_user
             store_location
             redirect_to root_path, :notice =>  "You must be logged in to access this page"
             return false
           end
         end

         def require_no_user
           if current_user
             store_location
             redirect_to root_path, :notice =>  "You must not be logged in to access this page"
             return false
           end
         end

         def store_location
           session[:return_to] = request.request_uri
         end

         def redirect_back_or_default(default)
           redirect_to(session[:return_to] || default)
           session[:return_to] = nil
         end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
end