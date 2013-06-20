require_relative 'test_helper'
require_relative '../lib/allmodels'

describe Todolist do
  include TestHelper

  let (:attributes)         { {:title => title, :user_id => user_id} }
  let (:title)              { "Great Expectations" }
  let (:user_id)            { 1 }
  subject (:todolist)       { Todolist.new(attributes) }

  it "should save itself when given proper attributes" do
    todolist.save.should == true
  end

  it "shouldn't save itself when given an empty title" do
    todolist.title = ""

    todolist.save.should == false
  end

  it "shouldn't save itself when given no user_id" do
    todolist.user_id = nil

    todolist.save.should == false
  end

  context "testing data access methods" do

    it "should find list by prefix of the title" do
      list = Todolist.find_by_prefix("Cztery")
      list.title.should == "Cztery to piekna liczba"
    end

    it "should find all lists that belong to a given User" do
      lists = Todolist.user_lists(1)
      lists.first.title.should == "Zrobie to tylko raz"
      lists.last.title.should == "Zrobie to tylko raz"
    end

    it "should find list by id eagerly loading its ListItems" do
      list = Todolist.find_by_id_eager(1)
      list.title.should == "Zrobie to tylko raz"
      list.todoitems.first.title.should == "Grac w gre"
      list.todoitems.count.should == 1
    end

  end

end
