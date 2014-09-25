

require_relative 'spec_helper'
require 'minitest/spec'

require 'timecost'

describe TimeCost::AuthorList do
	let(:author_list) { TimeCost::AuthorList.new }
	let(:author_first) { "foo@example.com" }
	let(:author_second) { "bar@example.com" }

	describe '.new' do
		it "can be created without arguments" do
			assert_instance_of TimeCost::AuthorList, author_list
		end
	end

	describe '.add' do
		it "must accept adding authors" do
			assert_respond_to author_list, :add

			author_list.add "foo@example.com"
			author_list.add "bar@example.com"
		end

		it "must assign a different id to different authors" do
			author_list.add "foo@example.com"
			author_list.add "bar@example.com"
			id_foo = author_list.parse "foo@example.com"
			id_bar = author_list.parse "bar@example.com"
			refute_equal id_foo, id_bar
		end
	end

	describe '.alias' do
		it "must accept aliases for authors" do 
			assert_respond_to author_list, :alias

			author_list.add author_first
			author_list.alias author_first, author_second 
		end

		it "must assign the same id to aliases authors" do
			author_list.add author_first
			author_list.alias author_first, author_second

			id_foo = author_list.parse author_first
			id_bar = author_list.parse author_second
			refute_equal id_foo, id_bar
		end
	end
end
