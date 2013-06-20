require_relative 'test_helper'
require_relative '../lib/allmodels'

describe User do
  include TestHelper

  let (:attributes)            { {:name => name, :surname => surname, :email => email, :terms_of_service => terms_of_service, :password => password, :password_confirmation => password_confirmation, :failed_login_count => failed_login_count} }
  let (:name)                  { "John" }
  let (:surname)               { "Smith" }
  let (:email)                 { "johnsmith@aol.com" }
  let (:terms_of_service)      { "1" }
  let (:password)              { "john123456" }
  let (:password_confirmation) { "john123456" }
  let (:failed_login_count)    { 0 }
  subject (:user)              { User.new(attributes) }

  it "should save itself when given proper attributes" do
    user.save.should == true
  end

  it "should not save itself when given an empty name" do
    user.name = ""

    user.save.should == false
  end

  it "should not save itself when given too long a name" do
    user.name = "a"*30

    user.save.should == false
  end

  it "should not save itself when given an empty surname" do
    user.surname = ""

    user.save.should == false
  end

  it "should not save itself when given too long a surname" do
    user.surname = "b"*40

    user.save.should == false
  end

  it "should not save itself when given an invalid email" do
    user.email = "@a.b"

    user.save.should == false
  end

  it "should not save itself when terms of service haven't been accepted" do
    user.terms_of_service = "0"

    user.save.should == false
  end

  it "should not save itself when given an empty password" do
    user.password = ""

    user.save.should == false
  end

  it "should not save itself when given too short a password" do
    user.password = "qwerty"

    user.save.should == false
  end

  it "should not save itself when password is not confirmed" do
    user.password_confirmation = ""

    user.save.should == false
  end

  it "should not save itself when password is not properly confirmed" do
    user.password_confirmation = "qw"

    user.save.should == false
  end

  it "should not save itself when failed_login_count is of a different type than integer" do
    user.failed_login_count = "a"

    user.save.should == false
  end

  context "testing data access methods" do

      it "should find user by surname" do
        user = User.find_by_surname("Adamski")
        user.surname.should == "Adamski"
      end

      it "should find user by email" do
        user = User.find_by_email("adam@adam.pl")
        user.email.should == "adam@adam.pl"
      end

      it "should find user by prefix of their surname" do
        user = User.find_by_prefix("Ada")
        user.surname.should == "Adamski"
      end

      it "should authenticate user using email and valid password" do
        user = User.find(1)
        user.authenticate("adam@adam.pl", "1234567890").should == true
      end

      it "should NOT authenticate user using email and invalid password" do
        user = User.find(1)
        user.authenticate("adam@adam.pl", "123").should == false
      end

      it "should find suspicious users with more than 2 failed_login_counts" do
        User.find_suspicious_users.count.should == 3
      end

      it "should group users by number of failed login attempts" do
        users = User.group_by_failed_login_count
        users.first.surname.should == "Erykowski"
        users.first.failed_login_count.should == 5
      end

  end

end
