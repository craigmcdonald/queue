require 'forwardable'

module Orderly
  class LinkedList
    extend Forwardable

    def_delegators :return_list_from_head, :count, :length
    attr_accessor :head, :uuid
    alias :first :head

    NodeNotFound = Class.new(ArgumentError)

    def initialize(val=nil,node=Node)
      @uuid = UUID.generate
      @node_factory = node
      @head = @node_factory.new(val) if val
    end

    def add_to_head(val)
      old_node, @head = @head, @node_factory.new(val,nil,@head)
      old_node.prev = @head if old_node
      self
    end

    alias :>> :add_to_head
    alias :unshift :add_to_head

    def add_to_tail(val)
      new_node = @node_factory.new(val,tail,nil)
      if @head
        tail.next = new_node
        recache_tail
      else
        @head = new_node
      end
      self
    end

    alias :<< :add_to_tail
    alias :push :add_to_tail

    def add_before(val,next_node)
      add(val,next_node,'prev')
    end

    def add_after(val,prev_node)
      add(val,prev_node,'next')
    end

    def pop
      tail.prev.next = nil
      tail
    end

    def shift
      current = @head
      @head = current.next
      @head.prev = nil
      current
    end

    def tail
      @tail ||= fetch_tail
    end

    alias :last :tail

    def recache_tail
      @tail = fetch_tail
    end

    def return_list_from_head
      list('next')
    end

    def return_list_from_tail
      list('prev')
    end

    def print_from_head
      return '' unless @head
      "[#{@head.val}] -> #{@head.next_vals.join(' -> ')}"
    end

    def print_from_tail
      return '' unless @head
      "#{tail.prev_vals.join(' <- ')} <- [#{tail.val}]"
    end

    def print_from_node(val)
      unless @head
        raise Orderly::LinkedList::NodeNotFound.new("Could not find a node with value of: #{val}")
      end
      current = @head
      current = current.next until current.val == val
      "#{current.prev_vals.join(' <- ')} <- [#{current.val}] -> #{current.next_vals.join(' -> ')}"
    end

    private

    def list(pos)
      current = pos == 'next' ? @head : tail
      array = []
      array << current.val && current = current.send(pos) until !current
      array
    end

    def fetch_tail
      return nil unless @head
      current = @head
      current = current.next until !current.next
      current
    end

    def add(val,node,pos,second_node=false)
      current = @head
      current = current.next until !current || current.val == node
      unless current
        raise Orderly::LinkedList::NodeNotFound.new("Could not find a node with value of: #{node}")
      end
      old_in_pos = current.send(pos)
      new_node = @node_factory.new(val).tap do |n|
        n.send("#{pos}=", old_in_pos)
        n.send("#{pos == 'prev' ? 'next' : 'prev'}=", current)
      end
      old_in_pos.send("#{pos == 'prev' ? 'next' : 'prev'}=", new_node) if old_in_pos
      current.send("#{pos}=", new_node)
      recache_tail unless old_in_pos && pos == 'next'
      self
    end
  end
end
