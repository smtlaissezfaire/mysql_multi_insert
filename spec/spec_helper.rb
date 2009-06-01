require File.dirname(__FILE__) + "/../lib/mysql_multi_insert"

require 'rubygems'
require 'mysql'
require 'active_record'
require 'yaml'

ActiveRecord::Base.establish_connection YAML.load(File.read(File.dirname(__FILE__) + "/db.yml"))
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :first_name
    t.timestamps
  end

  create_table :foos, :force => true do |t|
    t.timestamps
  end

  create_table :members, :force => true do |t|
    t.string :name
    t.timestamps
  end
end

class User < ActiveRecord::Base
  extend MysqlMultiInsert
end

class Foo < ActiveRecord::Base
  extend MysqlMultiInsert
end

class Member < ActiveRecord::Base
  extend MysqlMultiInsert

  validates_presence_of :name
end
