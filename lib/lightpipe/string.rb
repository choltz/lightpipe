module Lightpipe
  class String
    include Lightpipe
    include Lightpipe::Util

    # Create a function for all String methods: gsub, strip, etc.
    delegate_all_to_functions ::String

    # Capitalize all words in the given string
    function :capitalize_all, -> {
      String.split(/\s+/)     |
      Array.map(&:capitalize) |
      Array.join(' ')
    }

    function :remove_markup, -> { gsub /(<([^>]+)>)/, '' }

  end
end
