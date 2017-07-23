module Lightpipe
  class String
    include Lightpipe
    include Lightpipe::Util

    function :remove_markup, -> { gsub /(<([^>]+)>)/, '' }

    # Create a function for all String methods: gsub, strip, etc.
    interesting_methods(::String).each do |method|
      delegate_function method
    end
  end
end
