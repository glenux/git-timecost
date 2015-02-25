
require 'pp'

module TimeCost
	class AuthorList
		class UnknownAuthor < RuntimeError ; end

		# Prepare an empty index (local)
		def initialize
			@count = 0
			@author_to_id = {}
		end

		def add author
			if @author_to_id.include? author then
				result = @author_to_id[author]
			else
				@author_to_id[author] = @count
				result = @count
				@count += 1
			end
		end

		def alias author_ref, author_new
			raise UnknownAuthor unless @author_to_id.include? author_ref
		end

		# Return local user id for git user
		# FIXME: should handle multiple names for same user
		def parse author
			return @author_to_id[author]
		end

		def size
			return @author_to_id.keys.size
		end
	end
end
