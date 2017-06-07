module Orderly
  class Node

    attr_accessor :val, :prev, :next
    InvalidNextNode = Class.new(TypeError)
    InvalidPrevNode = Class.new(TypeError)

    def initialize(val,prev_node=nil,next_node=nil)
      @val = val
      @prev = valid_prev_or_next(prev_node,InvalidPrevNode,'Prev')
      @next = valid_prev_or_next(next_node,InvalidNextNode,'Next')
    end

    def next_vals
      traverse_nodes(@next,'next')
    end

    def prev_vals
      traverse_nodes(@prev,'prev').reverse
    end

    private

    def traverse_nodes(node,direction)
      return [] unless node
      array = []
      until !node do
        array << node.val
        node = node.send(direction)
      end
      array
    end

    def valid_prev_or_next(node,error,txt)
      return node if node.is_a? Node
      return nil unless node
      raise error.new("#{txt} node must be a Node or be nil.")
    end
  end
end
