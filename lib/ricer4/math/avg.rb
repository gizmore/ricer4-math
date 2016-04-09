module Ricer4::Plugins::Math
  class Avg < Ricer4::Plugin
    
    trigger_is "avg"

    has_usage "<..float|named:'numbers',multiple:true..>"
    def execute(floats)
      reply((floats.inject(0.0) { |sum, el| sum + el } / floats.size).to_s)
    end
    
  end
end