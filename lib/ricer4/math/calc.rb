module Ricer4::Plugins::Math
  class Calc < Ricer4::Plugin

    trigger_is :calc
    
    # Not too fast, cowboy
    bruteforce_protected timeout: 4.0.seconds

    # Max 1 thread per user
    denial_of_service_protected
    
    # Users can choose their own precision
    has_setting name: :precision, scope: :user, permission: :public, type: :integer, default: 128, min: 1, max: 2048

    # Own description function for function description    
    def plugin_description(long)
      t(:description,
        constants: join(MATH_CONSTANTS.keys.collect{|c|c.upcase}),
        functions: join(MATH_FUNCTIONS),
      )
    end
    
    #################
    ### Variables ###
    #################
    def plugin_init; @@variables = {}; end
    def v; @@variables[sender] ||= []; end

    PHI ||= 0.61803398874989
    MATH_CONSTANTS ||= {
      'e' => Math::E,
      'pi' => Math::PI,
      'tau' => 2*Math::PI,
      'phis' => 1-PHI, # phi short
      'phil' => PHI,   # phi long
      'phia' => 2.40,  # Golden arc short
      'phib' => 3.88,  # Golden arc long
      'phi' => 1+PHI,  # Golden ratio
    } 
    
    MATH_SYMBOLS ||= ['+', '-', '*', '/', '%', '^', '&', '(', ')', '|', '=', '$', ';']
    
    MATH_FUNCTIONS ||= [
    # math.rb from kernel mappings
    'acos', 'acosh',
    'asin', 'asinh',
    'atan', 'atan2', 'atanh',
#   'cbrt',
    'cos', 'cosh',
#   'erf', 'erfc',
    'exp',
#   'frexp',
#   'gamma',
#   'hypot',
#   'ldexp',
#   'lgamma',
    'log', 'log10', 'log2',
    'sin', 'sinh',
    'sqrt',
    'tan', 'tanh',
    # Other/Own helpers
    'round', 'floor', 'ceil',
    'deg', 'pow', 'root',
    ]
    
    has_usage '<math_term>'
    def execute(term)
      threaded {
        # Hacker Checker after some letter replacement, some functions will slip through
        if term_valid?(transform_term(term))
          # Replace user variables
          term.gsub!(/\$([1-9]?[0-9])/) { v[$1.to_i] ||= 0; 'v['+$1+']' }
          # Calculate
          v[0] = BigDecimal.new(eval(term), get_setting(:precision)) # Probably an exception, but ricer will catch ;)
          # Reply the result
          reply v[0].to_s.rtrim('0').rtrim('.')
        end
      }
    end
    
    private
    
    def transform_term(term)
      bot.log.debug("Maths#transform_term() from: #{term}")
      term.downcase!
      term.gsub!(',', '.')
      MATH_CONSTANTS.each{|k, v| term.gsub!(Regexp.new("([^a-z])#{k}([^a-z])")) { "#{$1} #{v} #{$2}" } }
      term.gsub!(/\s+/, ' ')
      #term.gsub!(/(\d) (\d)/) { "#{$1}*#{$2}" }
      term.strip!
      bot.log.debug("Maths#transform_term() done: #{term}")
      term
    end
    
    ########################
    ### Hacker Validator ###
    ########################
    def term_valid?(term)
      valid_symbols?(term)
      valid_variables?(term)
      valid_functions?(term)
    end

    def valid_symbols?(term)
      symbols = Regexp.escape(MATH_SYMBOLS.join)
      if !(/^[#{symbols}0-9\\.,a-z ]+$/.match(term))
        raise Ricer4::ExecutionException.new(t(:err_invalid_symbols))
      end
    end

    def valid_variables?(term)
      if /\$0\d/.match(term) || /\$\d{3,}/.match(term)
        raise Ricer4::ExecutionException.new(t(:err_invalid_variable))
      end
    end

    def valid_functions?(term)
      term.split(/[^a-z]+/).each do |func|
        unless MATH_FUNCTIONS.include?(func) || func.empty?
          raise Ricer4::ExecutionException.new(t(:err_invalid_function))
        end
      end
    end    

    #################
    ### Functions ###
    #################
    def acos(v); Math.acos(v); end
    def acosh(v); Math.acosh(v); end
    def asin(v); Math.asin(v); end
    def asinh(v); Math.asinh(v); end
    def atan(v); Math.atan(v); end
    def atan2(v); Math.atan2(v); end
    def atanh(v); Math.atanh(v); end
#   def cbrt(v); Math.cbrt(v); end
    def cos(v); Math.cos(v); end
    def cosh(v); Math.cosh(v); end
#   def erf(v); Math.erf(v); end
#   def erfc(v); Math.erfc(v); end
    def exp(v); Math.exp(v); end
#   def frexp(v); Math.frexp(v); end
#   def gamma(v); Math.gamma(v); end
#   def hypot(v); Math.hypot(v); end
#   def ldexp(v); Math.ldexp(v); end
#   def lgamma(v); Math.lgamma(v); end
    def log(v, base=nil); Math.log(v, base||Math::E); end
    def log10(v); Math.log10(v); end
    def log2(v); Math.log2(v); end
    def sin(v); Math.sin(v); end
    def sinh(v); Math.sinh(v); end
    def sqrt(v); Math.sqrt(v); end
    def tan(v); Math.tan(v); end
    def tanh(v); Math.tanh(v); end

    def pow(v, exp); v **= exp; end
    def root(v, root); v **= 1.0/root; end
    def ceil(v); v.ceil; end
    def floor(v); v.floor; end
    def round(v); v = v.round(get_setting(:precision)); end
    
    def deg(v); v.deg; end
    
  end
end
