require "bracket_error_suggestion"

module BracketErrorSuggestion

  module BracketAccess
    class << self
      def included(klass)
        klass.module_eval do
          alias_method :_get_without_be_suggestion, :[]
          alias_method :[], :_get_with_be_suggestion
        end
      end
    end

    attr_accessor :path_on_be_suggestion

    def _get_with_be_suggestion(name)
      if BracketErrorSuggestion.enabled
        begin
          r = _get_without_be_suggestion(name)
        rescue TypeError => e
          raise TypeError, "#{e.message}, it attempted to access #{_actual_path_on_be_suggestion}[#{name.inspect}] but #{_actual_path_on_be_suggestion} is an Array"
        end
        return r unless BracketErrorSuggestion.enabled
        case r
        when nil then
          BracketErrorSuggestion.nil_parent_paths << "#{_actual_path_on_be_suggestion}[#{name.inspect}]"
        when Array, Hash then
          r.path_on_be_suggestion = "#{_actual_path_on_be_suggestion}[#{name.inspect}]"
        end
        return r
      else
        return _get_without_be_suggestion(name)
      end
    end

    def _actual_path_on_be_suggestion
      path_on_be_suggestion || "<#{self.class.name}>"
    end
  end

end

