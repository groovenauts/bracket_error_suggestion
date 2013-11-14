require "bracket_error_suggestion/version"

module BracketErrorSuggestion

  class << self

    attr_reader :enabled
    def enable
      if block_given?
        @enabled, backup = true, @enabled
        begin
          return yield
        ensure
          @enabled = backup
          nil_parent_paths.clear unless @enabled
        end
      else
        @enabled = true
      end
    end

    def disable
      @enabled = false
      nil_parent_paths.clear
    end

    def nil_parent_paths
      @nil_parent_paths ||= []
    end

  end
end


require "bracket_error_suggestion/nil_ext"
require "bracket_error_suggestion/bracket_access"

nil.extend(BracketErrorSuggestion::NilExt)

Array.send(:include, BracketErrorSuggestion::BracketAccess)
Hash.send(:include, BracketErrorSuggestion::BracketAccess)
