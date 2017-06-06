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
    return [] unless @next
    node = @next
    nexts = []
    until !node do
      nexts << node.val
      node = node.next
    end
    nexts
  end

  def prev_vals
    return [] unless prev
    node = prev
    prevs = []
    until !node do
      prevs << node.val
      node = node.prev
    end
    prevs.reverse
  end

  private

  def valid_prev_or_next(node,error,txt)
    return node if node.is_a? Node
    return nil unless node
    raise error.new("#{txt} node must be a Node or be nil.")
  end
end
