module Ricer4::Plugins::Math
  class Rand < Ricer4::Plugin
    
    trigger_is :rand

    has_usage "<integer|named:'min'> <integer|named:'max'>", function: :execute_integer
    has_usage "<integer|named:'min'>", function: :execute_integer
    def execute_integer(min, max=nil)
      min, max = 1, min if max.nil?
      byebug
      reply(rand_int(min, max))
    end

    has_usage "<float|named:'min'> <float|named:'max'> <float|named:'step'>"
    has_usage "<float|named:'min'> <float|named:'max'>"
    has_usage "<float|named:'min'>"
    has_usage ""
    def execute(min=0.0, max=1.0, step=0.01)
      digits = step.to_s.length - 2
      rand = rand_float(min, max)
      rand -= rand % step
      reply(rand.round(digits).to_s)
    end
    
  end
end