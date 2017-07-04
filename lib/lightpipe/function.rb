module Lightpipe
  class Function < Proc
    # Public: build a composition of functions.
    #
    # functions - either an array of functions or a parameter list of functions
    #
    # Notes: The functions provided can be any class that has a call method
    #
    # Returns an instance of this class whose call method invokes the chain
    # of functions provided
    def self.compose(*functions)
      self.new do |arg|
        [functions].flatten.reduce(arg) do |result, function|
          function.call(result)
        end
      end
    end
  end
end
