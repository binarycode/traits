module Traits::Controller::Actions
  %W(index create update destroy edit).each {|v| require "traits/controller/actions/#{v}" }
  
  
  
end