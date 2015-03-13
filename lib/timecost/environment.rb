require 'active_record'
 
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.colorize_logging = false
 
ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :dbfile  => ":memory:"
)
 
ActiveRecord::Schema.define do
    create_table :albums do |table|
        table.column :title, :string
        table.column :performer, :string
    end
 
    create_table :tracks do |table|
        table.column :album_id, :integer
        table.column :track_number, :integer
        table.column :title, :string
    end
end
 
