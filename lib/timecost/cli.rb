module TimeCost
	class CLI
		def initialize
			# FIXME: accept multiple authors
			@config = {
				:author_filter_enable => false,
				:author_filter => ".*?",

				:date_filter_enable => false,
				:date_filter => ".*?",

				:input_dump => [],
				:output_dump => nil,

				:range_granularity => 0.5, # in decimal hours

				:verbose => false
			}
			@rangelist = {}
			@authorlist = nil
		end

		def parse_cmdline args
			opts = OptionParser.new do |opts|
				opts.banner = "Usage: #{File.basename $0} [options]"

				opts.on_tail("-v","--verbose", "Run verbosely") do |v|
					@config[:verbose] = true
				end

				opts.on_tail("-h","--help", "Show this help") do
					puts opts
					exit 0
				end

				opts.on("-i","--input FILE", "Set input dump file") do |file|
					@config[:input_dump] << file
				end

				opts.on("-o","--output FILE", "Set output dump file") do |file|
					@config[:output_dump] = file
				end

				opts.on("-d","--date DATE", "Keep only commits since DATE") do |date|
					puts "set date filter to #{date}"
					@config[:date_filter] = DateTime.parse(date);
					@config[:date_filter_enable] = true
				end

				opts.on("-t","--time TIME", "Keep only commits on last TIME datys") do |time|
					puts "set time filter to latest #{time} days"
					@config[:date_filter] = DateTime.now - time.to_f;
					puts "set date filter to date = #{@config[:date_filter]}"
					@config[:date_filter_enable] = true
				end

				opts.on("-a","--author AUTHOR", "Keep only commits by AUTHOR") do |author|
					puts "set author filter to #{author}"
					@config[:author_filter] = author
					@config[:author_filter_enable] = true
				end

				# overlap : 
				#
				opts.on("-s","--scotch GRANULARITY", "Use GRANULARITY (decimal hours) to merge ranges") do |granularity|
					puts "set scotch to #{granularity}"
					@config[:range_granularity] = granularity.to_f
				end
			end
			opts.parse! args

		end


		def analyze_git
			# git log
			# foreach, create time range (before) + logs
			process = IO.popen ["git", "log", 
					   "--date=iso", 
					   "--no-patch",
					   "--","."]


			@rangelist = {}
			commit = nil
			loop do
				line = process.gets
				break if line.nil?
				# utf-8 fix ?
				# line.encode!( line.encoding, "binary", :invalid => :replace, :undef => :replace)
				line.strip!

				case line
				when /^commit (.*)$/ then
					id = $1
					# merge ranges & push
					unless commit.nil? then
						range = Range.new @config, commit

						if not @rangelist.include? commit.author then
							@rangelist[commit.author] = RangeList.new
						end
						@rangelist[commit.author].add range
					end
					commit = Commit.new id
					# puts "commit #{id}"

				when /^Author:\s*(.*?)\s*$/ then
					unless commit.nil? then
						commit.author = $1 

						if @config[:author_filter_enable] and 
							(not commit.author =~ /#{@config[:author_filter]}/) then
							commit = nil
							# reject
						end

					end

				when /^Date:\s*(.*?)\s*$/ then
					unless commit.nil? then
						commit.date = $1

						if @config[:date_filter_enable] and 
							(DateTime.parse(commit.date) < @config[:date_filter]) then
							commit = nil
							# reject
						end
					end

				when /^\s*$/ then
					# skip

				else 
					# add as note
					unless commit.nil? then
						commit.note = if commit.note.nil? then line
								  	  else commit.note + "\n" + line
								  	  end
					end
				end

			end

		end

		def analyze_dumps
			#read ranges
			@rangelist = RangeList.new

			@config[:input_dump].each do |filename|
				rangelist = YAML::load(File.open(filename,"r"))
				rangelist.each do |range|
					@rangelist.add range
				end
			end
		end

		def analyze
			if @config[:input_dump].empty? then
				analyze_git
			else
				analyze_dumps
			end
		end

		def export
			return if @config[:output_dump].nil?
			puts "Exporting to %s" % @config[:output_dump]
			File.open(@config[:output_dump], "w") do |file|
				file.puts YAML::dump(@rangelist)
			end
		end

		def report
			return if not @config[:output_dump].nil?

			@rangelist.each do |author,rangelist|
				rangelist.each do |range|
					puts range.to_s + "\n"
				end
			end
			total = 0
			@rangelist.each do |author,rangelist|
				puts "SUB-TOTAL for %s: %.2f hours\n" % [author, rangelist.sum]
				total += rangelist.sum
			end
			puts "TOTAL: %.2f hours" % total
		end
	end
end

