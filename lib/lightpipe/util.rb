module Lightpipe
  module Util
    # Public: Hook class methods into the included class
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Public: Halts execution. Helpful for injecting a debbuger into the middle
      # of a composition
      def debugger
        Lightpipe::Function.new do |arg|
          Kernel.debugger
          arg
        end
      end

      # Public: Convert the given method name into a class function
      #
      # name - function name to convert
      #
      # Example:
      # class Test
      #   include Lightpipe::Util
      #
      #   delegate_function :gsub
      # end
      #
      # > Test.gsub.call(/_/, '-').call("test_test")
      # => "test-test"
      def delegate_function(name)
        (class << self; self; end).class_eval do
          define_method name do |*args, &block|
            Lightpipe::Function.new do |arg|
              arg.send(name, *args, &block)
            end
          end
        end
      end

      # Public: Create a function for all methods in klass that are not given
      # by virtue of Object.
      #
      # klass - klass whose methods should be added
      def delegate_methods_to_functions(klass)
        interesting_methods(klass).each do |method|
          delegate_function method
        end
      end

      # Public: Return a list of methods from the given class, minus methods
      # on the base Object class
      def interesting_methods(klass)
        klass.new.methods - Object.new.methods
      end

      # Public: Halts execution. Helpful for injecting binding.pry into the middle
      # of a composition
      def pry
        Lightpipe::Function.new do |arg|
          binding.pry
          arg
        end
      end

    end
  end
end
