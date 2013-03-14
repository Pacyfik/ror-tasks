require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }

  it { should be_empty }

  it "should raise an exception when nil is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should have size of 0" do
    list.size.should == 0
  end

  it "should accept an item" do
    list << item_description
    list.should_not be_empty
  end

  it "should add the item to the end" do
    list << item_description
    list.last.to_s.should == item_description
  end

  it "should have the added item uncompleted" do
    list << item_description
    list.completed?(0).should be_false
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end
  
  context "with more (three) items" do
    let(:items) { ["posprzatac", "wyniesc smieci", "umyc okna"] }
    before:each do
      list.complete(0)
    end
	
	it "should return completed items" do
	  list.completed.should == ["posprzatac"]
	end
	
	it "should return uncompleted items" do
	  list.uncompleted.should == ["wyniesc smieci", "umyc okna"]
	end	

	it "should remove an individual item" do
	  list.remove(0)
	  list.items[0].to_s.should == "wyniesc smieci"
	  expect { list.remove(nil) }.to raise_error
	end
	
	it "should remove all completed items" do
	  list.remove_completed
	  list.completed.should be_empty
	end
	
	it "should revert order of two items" do
	  list.revert(0,1)
	  list.items[0].to_s.should == "wyniesc smieci"
	  list.items[1].to_s.should == "posprzatac"
	  expect { list.revert(nil) }.to raise_error
	end
	
	it "should revert order of all items" do
	  list.revert_all
	  list.items[0].to_s.should == "umyc okna"
	  list.items[2].to_s.should == "posprzatac"
	end
	
	it "should toggle the state of an item" do
	  list.toggle(0)
	  list.completed?(0).should be_false
	  expect { list.toggle(nil) }.to raise_error
	end
	
	it "should set the state of an item to uncompleted" do
	  list.uncomplete(0)
	  list.completed?(0).should be_false
	  expect { list.uncomplete(nil) }.to raise_error
	end
	
	it "should change the description of an item" do
	  list.change_desc(0, "odpoczac sobie")
	  list.items[0].to_s.should == "odpoczac sobie"
	  expect { list.change_desc(nil) }.to raise_error
	end
	
	it "should sort the items by name" do
	  list.sort_by_name
	  list.items[0].to_s.should == "posprzatac"
	  list.items[1].to_s.should == "umyc okna"
	  list.items[2].to_s.should == "wyniesc smieci"
	end
	
	it "should convert the list to text with specific format" do
	  list.to_text.should == "[x] posprzatac\n[ ] wyniesc smieci\n[ ] umyc okna\n"
	end
	
  end
  
end
