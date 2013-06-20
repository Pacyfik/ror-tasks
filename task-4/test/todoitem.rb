require_relative 'test_helper'
require_relative '../lib/allmodels'

describe Todoitem do
  include TestHelper

  let (:attributes)     { {:title => title, :todolist_id => todolist_id, :description => description, :date_due => date_due} }
  let (:title)          { "Buy beer" }
  let (:todolist_id)    { 1 }
  let (:description)    { "Self explanatory" }
  let (:date_due)       { "11/11/2011" }
  subject (:todoitem)   { Todoitem.new(attributes) }

  it "should save itself when given proper attributes" do
    todoitem.save.should == true
  end

  it "shouldn't save itself when given an empty title" do
    todoitem.title = ""

    todoitem.save.should == false
  end

  it "shouldn't save itself when given too short a title" do
    todoitem.title = "qwer"

    todoitem.save.should == false
  end

  it "shouldn't save itself when given too long a title" do
    todoitem.title = "a"*40

    todoitem.save.should == false
  end

  it "shouldn't save itself when given no todolist_id" do
    todoitem.todolist_id = ""

    todoitem.save.should == false
  end

  it "shouldn't save itself when given too long a description" do
    todoitem.description = "b"*300

    todoitem.save.should == false
  end

  it "shouldn't save itself when given a date in a wrong format" do
    todoitem.date_due = "2011-11-11"

    todoitem.save.should == false
  end

  context "testing data access methods" do

    #not really done, only checks for a substring
    it "should find items with a specific word in a description" do
      item = Todoitem.find_by_word("Raider")
      item.title.should == "Grac w gre"
    end

    it "should find items with description exceeding 100 characters" do
      items = Todoitem.find_by_long_desc
      items.first.title.should == "Znalezc domek bez adresu"
    end

    it "should paginate items with 5 items per page and order them by title" do
      items = Todoitem.paginate(1)
      items.first.title.should == "Amu, jesc, jesc"
    end

    it "should find all items that belong to a given user (use eager loading)" do
      items = Todoitem.find_user_items(1)
      items.first.title.should == "Grac w gre"
    end

    it "should find items that belong to a specific user that are due to midnight of a specific day" do
      items = Todoitem.find_user_items_due_by_date(1, "2/7/2013")
      items.first.title.should == "Grac w gre"
    end

    it "should find items that are due for a specific day" do
      items = Todoitem.find_items_due_by_day("2/7/2013")
      items.first.title.should == "Grac w gre"
    end

    it "should find items that are due for a specific week" do
      items = Todoitem.find_items_due_by_week(27)
      items.count.should == 2
    end

    it "should find items that are due for a specific month" do
      items = Todoitem.find_items_due_by_month(7)
      items.count.should == 2
    end

    #today excluded
    it "should find items that are overdue" do
      items = Todoitem.find_items_overdue
      items.count.should == 1
    end

    it "should find items that are due in the next n hours" do
      items = Todoitem.find_items_due_in_n_hours(50)
      items.count.should == 0
    end

  end

end
