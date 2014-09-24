

require_relative 'spec_helper'
require 'minitest/spec'

describe "simple failing test" do
	it "fails" do
		assert 1 < 0
	end
end
