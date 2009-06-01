require File.dirname(__FILE__) + "/../lib/mysql_multi_insert"

require 'rubygems'
require 'mysql'
require 'active_record'

ActiveRecord::Base.establish_connection \
:adapter => 'mysql',
:database  => 'mysql_multi_insert_tests',
:user => "root"

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :first_name
    t.timestamps
  end

  create_table :foos, :force => true do |t|
    t.timestamps
  end
end

class User < ActiveRecord::Base
  extend MysqlMultiInsert
end

class Foo < ActiveRecord::Base
  extend MysqlMultiInsert
end
