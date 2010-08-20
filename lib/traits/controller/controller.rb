require 'traits/controller/resource'
module Traits::Controller
  %W(index create update destroy).each {|v| require "actions/#{v}"}
   
end