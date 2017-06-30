require 'test_helper'

class LightpipeTest < Minitest::Test
  context "base tests" do
    should "have a version number" do
      refute_nil ::Lightpipe::VERSION
    end
  end
end
