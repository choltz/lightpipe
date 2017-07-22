module Lightpipe
  class String
    include Lightpipe
    include Lightpipe::Util

    function :remove_markup, -> {
      gsub /(<([^>]+)>)/, ''
    }

    # This may be overkill, but create a function for all String methods
    ::String.new.methods.each do |method|
      delegate_function method
    end
  end
end
