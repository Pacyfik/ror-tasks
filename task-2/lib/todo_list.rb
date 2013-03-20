class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items[:db] == nil
	  raise IllegalArgument
	else
	  @db = items[:db]
	  @network = items[:social_network] if items[:social_network]
	end
  end
  
  def empty?
    @db.items_count == 0 ? true : false
  end
  
  def size
    @db.items_count
  end
  
  def <<(item)
    if item == nil || item.title == "" || item.title.length < 5
	  nil
	else
	  @db.add_todo_item(item)
	  shorten_title(item)
	  @network.notify(item) if @network
	end
  end 
  
  def first
    @db.items_count == 0 ? nil : @db.get_todo_item(0)
  end
  
  def last
    @db.items_count == 0 ? nil : @db.get_todo_item(@db.items_count - 1)
  end
  
  def toggle_state(id)
    if @db.get_todo_item(id)
      if @db.todo_item_completed?(id)
	    @db.complete_todo_item(id,false)
	  else  
	    @db.complete_todo_item(id,true)
		item = @db.get_todo_item(id)
		shorten_title(item)
	    @network.notify(item) if @network
	  end
	else
	  raise IllegalArgument
	end
  end
  
  def shorten_title(item)
    item.title = item.title[0...255]
  end
 
end
