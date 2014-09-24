
module TimeCost
	class Range
		attr_accessor :time_start, :time_stop, :commits, :author

		def initialize config, commit
			@config = config

			# FIXME: First approximation for users
			# later, we'll replace with @user = User.parse(commit.author)
			@author = commit.author

			@time_stop = DateTime.parse(commit.date)
			@time_start = @time_stop - (@config[:range_granularity] * 3 / 24.0)
			@commits = [commit]
			self
		end

		def merge range
			#  B -----[----]----
			#  A  --[----]------
			#  = ---[------]----

			# minimum of both
			new_start = if range.time_start < @time_start then range.time_start
						else @time_start
						end

			new_end = if range.time_stop >= @time_stop then range.time_stop
					  else @time_stop
					  end

			@time_start = new_start
			@time_stop = new_end
			@commits.concat range.commits
		end

		def overlap? range
			result = false

			# return early result if ranges come from different authors
			return false if (@author != range.author)

			# Ref ----[----]-----
			# overlapping :
			#  A  -[----]--------
			#  B  -------[----]--
			#  C  -[----------]--
			#  D  ------[]-------
			# non-overlapping : 
			#  E  -[]------------
			#  F  -----------[]--

			start_before_start = (range.time_start < @time_start)
			start_after_start = (range.time_start >= @time_start)
			start_after_stop = (range.time_start >= @time_stop)
			start_before_stop = (range.time_start < @time_stop) 

			stop_before_stop = (range.time_stop < @time_stop)
			stop_after_stop = (range.time_stop >= @time_stop)
			stop_before_start = (range.time_stop < @time_start)
			stop_after_start = (range.time_stop >= @time_start)

			# A case
			if start_before_start and start_before_stop and
				stop_after_start and stop_before_stop then
				result = true
			end

			# B case
			if start_after_start and start_before_stop and
				stop_after_start and stop_after_stop then
				result = true
			end

			# C case
			if start_before_start and start_before_stop and
				stop_after_start and stop_after_stop then
				result = true
			end

			# D case
			if start_after_start and start_before_stop and
				stop_after_start and stop_before_stop then
				result = true
			end

			return result
		end

		def fixed_start 
			return @time_start + (@config[:range_granularity]/24.0)
		end

		def diff 
			return ("%.2f" % ((@time_stop - fixed_start).to_f * 24)).to_f
		end

		def to_s 
			val = "(%s) %s - %s\n" % [diff, fixed_start, @time_stop]	
			@commits.each do |commit|
				lines = []
				unless @config[:author_filter_enable] then
					lines.push commit.author
				end
				lines.concat commit.note.split(/\n/)
				r = lines.map{ |s| "\t  %s" % s }.join "\n"
				r[1] = '*'
				val += r + "\n"
			end
			return val
		end
	end
end

