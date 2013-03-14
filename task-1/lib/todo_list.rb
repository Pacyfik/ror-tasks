class TodoList
  attr_accessor :items

  class Item
    attr_accessor :desc, :completed
	
	def initialize(item)
	  @desc = item
	  @completed = false
	end
	
	def to_s
	  @desc
	end
	
  end  
  
  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
	if items == nil
	  raise IllegalArgument
	else
	  @items = []
	  items.each do |item|
	    @items << Item.new(item)
	  end
    end
  end
  
  def empty?
	@items.empty?
  end
  
  def size
	@items.size
  end
  
  def <<(item)
	@items << Item.new(item)
  end
  
  def last
	@items.last
  end
  
  def first
	@items.first
  end
  
  def completed?(id)
	@items[id].completed
  end
  
  def complete(id)
    @items[id].completed = true
  end
  
  def completed
    @list = []
    @items.each do |i|
	  if i.completed
        @list << i.desc
      end
	end
	@list
  end
  
  def uncompleted
    @list = []
    @items.each do |i|
	  unless i.completed
        @list << i.desc
      end
	end
	@list
  end
  
  def remove(id)
    @items.delete_at(id)
  end

  def remove_completed
    @items.each do |i|
	  if i.completed
		@items.delete(i)
      end
	end
  end
  
  def revert(id1, id2)
    @items[id1], @items[id2] = @items[id2], @items[id1]
  end
  
  def revert_all
    @items.reverse!
  end
  
  def toggle(id)
    if @items[id].completed == true
	  @items[id].completed = false
	else
	  @items[id].completed = true
	end
  end
  
  def uncomplete(id)
    @items[id].completed = false
  end
  
  def change_desc(id, desc)
    @items[id].desc = desc
  end
  
  def sort_by_name
    @items.sort! { |a,b| a.desc.downcase <=> b.desc.downcase }
  end
  
  def to_text
    text = ""
    @items.each do |i|
	  if i.completed
        text << "[x] "+i.desc+"\n"
	  else
	    text << "[ ] "+i.desc+"\n"
	  end
	end
	text
  end
	
end
