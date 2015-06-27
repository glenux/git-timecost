
require_relative 'spec_helper'

require 'timecost/range'

describe TimeCost::Range do
	let(:config) do { granularity: 0.5 } end

	let(:commitA) { nil }
	let(:commitB) { nil }
	let(:commitC) { nil }
	let(:commitD) { nil }

	let(:rangeA) { 
		TimeCost::Range.new commitA, config 
	}

	describe '.new' do
		it "can be created from " do
			assert_instance_of TimeCost::Range, rangeA
		end
	end

	# Ref ----[----]-----
	# overlapping :
	#  A  -[----]--------
	#  B  -------[----]--
	#  C  -[----------]--
	#  D  ------[]-------
	# non-overlapping : 
	#  E  -[]------------
	#  F  -----------[]--
	describe '.overlap?' do
		it "must respond to .overlap?" do
		end

		it "must return false when ranges are not overlapping" do
			# rangeRef = RangeV2.new
			# rangeA = RangeV2.new ...
			# FIXME: test rangeRef + rangeA
			#
			# rangeB = RangeV2.new
			# FIXME: test rangeRef + rangeB
			#
			# rangeC = RangeV2.new
			# FIXME: test rangeRef + rangeC
			#
			# rangeD = RangeV2.new
			# FIXME: test rangeRef + rangeD
			#
			# rangeE = RangeV2.new
			# FIXME: test rangeRef + rangeE
			#
			# rangeF = RangeV2.new
			# FIXME: test rangeRef + rangeF
		end

		it "must return true when ranges are overlapping" do
		end
	end
end

