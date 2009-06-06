require File.dirname(__FILE__) + "/spec_helper"

describe MysqlMultiInsert do
  def clear_db
    User.delete_all
    Foo.delete_all
    Member.delete_all
  end

  before do
    clear_db
  end

  it "should be able to insert a new record" do
    lambda {
      u = User.new
      User.multi_insert [u]
    }.should change { User.count }.by(1)
  end

  it "should be able to insert two new records" do
    lambda {
      u1 = User.new
      u2 = User.new
      
      User.multi_insert [u1, u2]
    }.should change { User.count }.by(2)
  end

  it "should use the correct table name" do
    one = Foo.new

    lambda {
      Foo.multi_insert [one]
    }.should change { Foo.count }.by(1)
  end

  it "should use one correct value" do
    u = User.new(:first_name => "Scott")

    User.multi_insert [u]

    u = User.find(:first)
    u.first_name.should == "Scott"
  end

  it "should use only one execute statement" do
    User.connection.should_receive(:execute).once
    User.multi_insert [User.new, User.new]
  end

  it "should do nothing with an empty array" do
    User.connection.should_not_receive(:execute)
    
    User.multi_insert []
  end

  describe "validations" do
    it "should insert when passed skip_validation => true" do
      m = Member.new

      lambda {
        Member.multi_insert [m], :skip_validations => true
      }.should change { Member.count }.by(1)
    end

    it "should not insert when passed skip_validations => false" do
      m = Member.new

      lambda {
        Member.multi_insert [m], :skip_validations => false
      }.should_not change { Member.count }
    end

    it "should not insert invalid records by default" do
      m = Member.new

      lambda {
        Member.multi_insert [m]
      }.should_not change { Member.count }
    end
  end
  
  it "should be at version = 1.0.0" do
    MysqlMultiInsert::VERSION.should == "1.0.0"
  end
end
