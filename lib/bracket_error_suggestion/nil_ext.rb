require "bracket_error_suggestion"

module BracketErrorSuggestion

  module NilExt
    class << self
      def extended(obj)
        obj.instance_eval do
          alias :method_missing_without_bracket_error_suggestion :method_missing
          alias :method_missing :method_missing_with_bracket_error_suggestion
        end
      end
    end

    def method_missing_with_bracket_error_suggestion(name, *args, &block)
      return method_missing_without_bracket_error_suggestion(name, *args, &block) unless BracketErrorSuggestion.enabled
      case name
      when :[] then
        key = args.first
        raise NoMethodError, "undefined method `[]' for nil:NilClass, maybe it attempted to access: " +
          BracketErrorSuggestion.nil_parent_paths.reverse.map{|path| "#{path}[#{key.inspect}] but #{path} is nil"}.join(", ")
      end
      return method_missing_without_bracket_error_suggestion(name, *args, &block)
    end
  end
end
