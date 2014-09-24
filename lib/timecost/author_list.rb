
module TimeCost
	class AuthorList
		# Prepare an empty index (local)
		def initialize
			@count = 0
			@store = {}
		end

		# Return local user id for git user
		# FIXME: should handle multiple names for same user
		def parse gitauthor
			invert_store = @store.invert
			result = 0
			if invert_store.include? gitauthor then
				result = invert_store[gitauthor]
			else
				@store[gitauthor] = @count
				result = @count
				@count += 1
			end
		end
	end
end
