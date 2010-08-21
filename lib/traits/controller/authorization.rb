module Traits::Controller::Authorization
  %W( authlogic ).each {|v| require "traits/controller/authorizations/#{v}" }
  
end