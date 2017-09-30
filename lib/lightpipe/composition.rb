module Lightpipe
  # Public: Include this to a class to gice it a functional composition operator
  module Composition
    # Public: Hook class methods into the included class
    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, InstanceMethods
    end

    module ClassMethods
      # Public: build a composition of functions.
      #
      # functions - either an array of functions or a parameter list of functions
      #
      # Notes: The functions provided can be any class that have a call method
      #
      # Returns an instance of this class whose call method invokes the chain
      # of functions provided
      def compose(*functions)
        new do |arg|
          [functions].flatten.reduce(arg) do |result, function|
            function.call(result)
          end
        end
      end
    end

    module InstanceMethods
      # Public: Override the pipe operator to simplify functional composition
      #
      # function - function to compose with the current function
      #
      # Examples
      #
      # > functions = strip_string | remove_markup | capitalize
      # > functions.call("  <b>this is a test</b>  ")
      # => "This is a test"
      #
      # Returns a composition of the two functions
      def |(other)
        self.class.compose(self, other)
      end

    end
  end
end
