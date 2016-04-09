require "ricer4"
module Ricer4
  module Plugins
    module Math
      
      VERSION ||= "4.0.0"
      
      add_ricer_plugin_module(File.dirname(__FILE__)+'/ricer4/math')
      
    end
  end
end