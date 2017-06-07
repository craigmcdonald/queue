require 'spec_helper'

describe Orderly::Node do

  let(:next_node) {  described_class.new('next_node', nil) }
  let(:prev_node) {  described_class.new('prev_node', nil) }

  it 'should accept a string as a value and nil as a value for prev_node & next_node' do
    expect {described_class.new('string',nil,nil)}.to_not raise_error
  end

  it 'should not accept a string as next_node' do
    expect {described_class.new('string',nil,'string')}
    .to raise_error Orderly::Node::InvalidNextNode, 'Next node must be a Node or be nil.'
  end

  it 'should accept a Node as a value for next_node' do
    expect {described_class.new('string',nil, next_node)}.to_not raise_error
  end

  it 'should accept a Node as a value for prev_node' do
    expect {described_class.new('string',prev_node)}.to_not raise_error
  end

  it 'should not accept a string as a value for prev_node' do
    expect {described_class.new('string','string')}
    .to raise_error Orderly::Node::InvalidPrevNode, 'Prev node must be a Node or be nil.'
  end

  describe 'other nodes' do

    before(:each) do
      @first_node = described_class.new('prev_node')
      @second_node = described_class.new('next_node')
      third_node = described_class.new('string',@first_node,@second_node)
      @first_node.next = third_node
      @second_node.prev = third_node
    end

    it 'should list [string, next_node] for #next_vals' do
      expect(@first_node.next_vals).to eq(['string','next_node'])
    end

    it 'should list [prev_node, string] for #next_vals' do
      expect(@second_node.prev_vals).to eq(['prev_node','string'])
    end

  end

  describe 'returning the correct values for next and prev nodes' do
    let(:node) { described_class.new('string',prev_node,next_node)}

    it "should return 'prev_node' as the value of its previous node" do
      expect(node.prev.val).to eq 'prev_node'
    end

    it "should return 'next_node' as the value of its next node" do
      expect(node.next.val).to eq 'next_node'
    end

  end

  describe 'its attributes' do
    let(:node) { described_class.new(1) }

    it 'should respond_to val' do
      expect(node).to respond_to(:val)
    end

    it 'should respond_to next' do
      expect(node).to respond_to(:next)
    end

    it 'should respond_to prev' do
      expect(node).to respond_to(:prev)
    end
  end
end
