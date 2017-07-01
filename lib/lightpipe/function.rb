module Lightpipe
  class Function < Proc
    def self.compose(*functions)
      self.new do |args|
        [functions].flatten.reduce(args) do |result, function|
          function.call(result)
        end
      end
    end
  end
end
