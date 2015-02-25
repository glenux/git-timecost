
module TimeCost

	class Commit
		attr_accessor :author, :commit, :date, :note
		def initialize commit
			@commit = commit
			@note = nil
			@author = nil
			@date = nil
		end

	end
end
