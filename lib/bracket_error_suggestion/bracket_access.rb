require "bracket_error_suggestion"

module BracketErrorSuggestion

  module BracketAccess
    class << self
      def included(klass)
        klass.module_eval do
          alias_method :get_without_trace, :[]
          alias_method :[], :get_with_trace
        end
      end
    end

    attr_accessor :path

    def get_with_trace(name)
      if BracketErrorSuggestion.enabled
        begin
          r = get_without_trace(name)
        rescue TypeError => e
          s = path || "<#{self.class.name}>"
          raise TypeError, "#{e.message}, it attempted to access #{s}[#{name.inspect}] but #{s} is an Array"
        end
        return r unless BracketErrorSuggestion.enabled
        case r
        when nil then
          s = path || "<#{self.class.name}>"
          BracketErrorSuggestion.nil_parent_paths << "#{s}[#{name.inspect}]"
        when Array, Hash then
          s = path || "<#{self.class.name}>"
          r.path = "#{s}[#{name.inspect}]"
        end
        return r
      else
        return get_without_trace(name)
      end
    end

  end

end

