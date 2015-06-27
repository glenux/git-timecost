
ActiveRecord::Schema.define do
 	create_table :ranges_v2 do |table|
        table.column :granularity, :float
        table.column :author, :string
        table.column :time_start, :date
        table.column :time_stop, :date
	end
end

module TimeCost
	class RangeV2 < ActiveRecord::Base
		has_many :commits_v2

		GRANULARITY_DEFAULT = 0.5

		def to_s show_authors = true
			val = "(%s)\t%s - %s\n" % [diff, fixed_start, @time_stop]	
			if show_authors  then
				val += "\tby %s\n" % @commits.first.author
			end
			@commits.each do |commit|
				lines = []
				lines.concat commit.note.split(/\n/)
				r = lines.map{ |s| "\t  %s" % s }.join "\n"
				r[1] = '*'
				val += r + "\n"
			end
			return val
		end
	end

	class Range 
		attr_accessor :time_start, :time_stop, :commits, :author

		GRANULARITY_DEFAULT = 0.5

		def initialize commit, options = {}
			@granularity = options[:granularity] || GRANULARITY_DEFAULT

			# FIXME: First approximation for users
			# later, we'll replace with @user = User.parse(commit.author)
			@author = commit.author

			@time_stop = DateTime.parse(commit.date)
			@time_start = @time_stop - (@granularity * 3 / 24.0)
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
			return @time_start + (@granularity/24.0)
		end

		def diff 
			return ("%.2f" % ((@time_stop - fixed_start).to_f * 24)).to_f
		end

		def to_s show_authors = true
			val = "(%s)\t%s - %s\n" % [diff, fixed_start, @time_stop]	
			if show_authors  then
				val += "\tby %s\n" % @commits.first.author
			end
			@commits.each do |commit|
				lines = []
				lines.concat commit.note.split(/\n/)
				r = lines.map{ |s| "\t  %s" % s }.join "\n"
				r[1] = '*'
				val += r + "\n"
			end
			return val
		end
	end
end

