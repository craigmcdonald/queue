require 'forwardable'

class LinkedList
  extend Forwardable

  def_delegator :return_list, :count
  attr_accessor :head

  def initialize(val,node=Node)
    @node_factory = node
    @head = @node_factory.new(val)
  end

  def add_to_head(val)
    old_node, @head = @head, @node_factory.new(val,nil,@head)
    old_node.prev = @head
    self
  end

  alias :<< :add_to_head

  def add_to_tail(val)
    tail.next = @node_factory.new(val,tail,nil)
    recache_tail
    self
  end

  alias :>> :add_to_tail

  def add_before(val,next_node)
    add(val,next_node,'prev')
  end

  def add_after(val,prev_node)
    add(val,prev_node,'next')
  end

  def tail
    @tail ||= fetch_tail
  end

  def recache_tail
    @tail = fetch_tail
  end

  def return_list
    list('next')
  end

  def return_list_from_tail
    list('prev')
  end

  def list(pos)
    current = pos == 'next' ? @head : tail
    array = []
    array << current.val && current = current.send(pos) until !current
    array
  end

  def print_from_head
    "[#{@head.val}] -> #{@head.next_vals.join(' -> ')}"
  end

  def print_from_tail
    "#{tail.prev_vals.join(' <- ')} <- [#{tail.val}]"
  end

  def print_from_node(val)
    current = @head
    current = current.next until current.val == val
    "#{current.prev_vals.join(' <- ')} <- [#{current.val}] -> #{current.next_vals.join(' -> ')}"
  end

  private

  def fetch_tail
    current = @head
    current = current.next until !current.next
    current
  end

  def add(val,node,pos,second_node=false)
    current = @head
    current = current.next until current.val == node
    old_in_pos = current.send(pos)
    new_node = @node_factory.new(val).tap do |n|
      n.send("#{pos}=", old_in_pos)
      n.send("#{pos == 'prev' ? 'next' : 'prev'}=", current)
    end
    old_in_pos.send("#{pos == 'prev' ? 'next' : 'prev'}=", new_node)
    current.send("#{pos}=", new_node)
    self
  end
end
