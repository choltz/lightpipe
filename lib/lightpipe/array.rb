module Lightpipe
  class Array
    include Lightpipe
    include Lightpipe::Util

    # Create a function for all Array methods: map, select, etc.
    delegate_all_to_functions ::Array

  end
end
