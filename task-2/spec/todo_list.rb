require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    stub(database).items_count { 1 }
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    mock(database).get_todo_item(0).times(3) { item }
    mock(database).todo_item_completed?(0) { false }
    mock(database).complete_todo_item(0,true) { true }
    mock(database).todo_item_completed?(0) { true }
    mock(database).complete_todo_item(0,false) { true } 

    list.toggle_state(0)
    list.toggle_state(0)
  end

  it "should fetch the first item from the DB" do
    stub(database).items_count { 1 }
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end
  
  it "should return nil for the first and the last item if the DB is empty" do
    stub(database).items_count { 0 }
	
	list.first.should == nil
	list.last.should == nil
  end
  
  it "should raise an exception when changing the item state if the item is nil" do
    mock(database).get_todo_item(5) { nil }
  
    expect{ list.toggle_state(5) }.to raise_error(IllegalArgument)
  end
  
  context "with a nil item" do
    let(:item)   { nil }

    it "should not accept a nil item" do
      dont_allow(database).add_todo_item(item)
	  
      list << item
    end
  end
  
  context "with a short item title" do
    let(:title)   { "PHP" }

    it "should not accept an item with too short (but not empty) title" do
      dont_allow(database).add_todo_item(item)
	  
      list << item
    end
  end
  
  context "with missing description" do
    let(:description)   { nil }

    it "should accept an item with missing description" do
      stub(database).items_count { 1 }
	  mock(database).add_todo_item(item) { true }
      mock(database).get_todo_item(0) { item }
	  
      list << item
	  list.first.should == item
    end
  end
  
  context "with social network added" do
    subject(:list)     { TodoList.new(db: database, social_network: network) }
	let(:network)      { mock }

	it "notifies a social network if an item is added to the list" do
	  mock(network).notify(item) { true }
	  mock(database).add_todo_item(item) { true }
	
	  list << item
	end
	
	it "notifies a social network if an item is completed" do
	  mock(network).notify(item) { true }
	  mock(database).get_todo_item(0).times(2) { item }
	  mock(database).todo_item_completed?(0) { false }
	  mock(database).complete_todo_item(0,true) { true }
	  
	  list.toggle_state(0)
	end
	
    context "with no title of the item" do
	  let(:title)               { "" }
	  
	  it "doesn't notify the social network if the title of the item is missing" do
	    mock(network).notify(item).times(0)
	    #or dont_allow(network).notify(item)
	
	    list << item
	  end
	end  

    context "with no body of the item" do
	  let(:description)               { "" }
	  
	  it "notifies the social network if the body of the item is missing" do
	    mock(network).notify(item) { true }
		mock(database).add_todo_item(item) { true }
	   
	    list << item
	  end
	end  
	
    context "with item's body longer than 255 characters" do
	  let(:description)               { "qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 qwertyui1 " }	
 
	  it "cuts the title of the item when notifying the SN if it is longer than 255 chars (both when adding and completing the item)" do
	    mock(database).add_todo_item(item) { true }
	    mock(network).notify(item).times(2) { true }
	    mock(database).get_todo_item(0).times(2) { item }
	    mock(database).todo_item_completed?(0) { false }
	    mock(database).complete_todo_item(0,true) { true }
	
	    list << item
	    item.title.length.should <= 255
	    list.toggle_state(0)
	    item.title.length.should <= 255
	  end
    end
	
  end
  
end
