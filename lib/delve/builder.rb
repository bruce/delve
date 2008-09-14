require 'ripper'

module Delve
  
  class Builder < ::Ripper::SexpBuilderPP
  
    attr_reader :comments
    def comments
      @comments ||= {}
    end
    
    private
    
    # Ripper discards comments when building the sexp,
    # so we maintain a separate mapping for lookup
    def on_comment(text)
      if comments[lineno]
        text = [comments.delete(lineno), text].join
      end
      comments[lineno + 1] = text
    end

  end
  
end