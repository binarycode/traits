module Traits::Controller::Actions
  %W(index create update destroy show edit new).each {|v| require "traits/controller/actions/#{v}" }
  
  
  
end