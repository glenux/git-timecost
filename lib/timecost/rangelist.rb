
module TimeCost
	class RangeList
		def initialize
			@ranges = []
		end

		def add range
			merged = false
			merged_range = nil

			# merge
			@ranges.each do |old|
				#pp old
				if old.overlap? range then
					old.merge range
					merged_range = old
					merged = true
					break
				end
			end

			# add if needed
			if merged then
				@ranges.delete merged_range
				self.add merged_range
			else 
				@ranges.push range
			end
		end

		def each 
			@ranges.each do |r|
				yield r
			end
		end

		def sum
			result = 0
			@ranges.each do |r|
				result += r.diff
			end
			return result
		end
	end
end
