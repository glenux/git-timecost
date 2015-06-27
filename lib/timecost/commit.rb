
ActiveRecord::Schema.define do
    create_table :commits_v2 do |table|
        table.column :commit, :string # ref to object
        table.column :note, :string
        table.column :author, :author
        table.column :date, :date
		table.column :range_id, :integer
    end
end

module TimeCost
	class CommitV2 < ActiveRecord::Base 
		belongs_to :ranges_v2
	end

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
