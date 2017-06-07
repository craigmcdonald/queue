require 'spec_helper'

describe Orderly::LinkedList do
  subject { described_class }

  it 'should not raise an error on initialization with no arg' do
    expect { subject.new }.to_not raise_error
  end

  it 'should not raise an error on initialization with a string' do
    expect { subject.new('string') }.to_not raise_error
  end

  it 'should not raise an error on initialization with an int' do
    expect { subject.new(1) }.to_not raise_error
  end

  describe 'adding nodes' do

    let(:linked_list) { described_class.new(1)}

    describe 'adding a node to the head' do

      describe 'uuid' do

        it 'should have a uuid that ends with 1' do
          allow(Orderly::UUID).to receive(:generate)
            .and_return('8df1770b-e6fa-6179-8569-000000000001')
          expect(linked_list.uuid).to end_with('1')
        end
      end

      it 'should have a node at head when initialized' do
        expect(linked_list.head.val).to eq(1)
      end

      describe 'adding a second node to the head' do
        before(:each) { linked_list.add_to_head(2) }

        it 'should have a new node at head when #add_to_head is called' do
          expect(linked_list.first.val).to eq(2)
        end

        it 'should have the new node at head which should have the old node at next' do
          expect(linked_list.head.next.val).to eq(1)
        end

        it 'should have the old node with the new node at prev' do
          expect(linked_list.head.next.prev.val).to eq(2)
        end

        it 'should return an array of values [2,1]' do
          expect(linked_list.return_list_from_head).to eq([2,1])
        end
      end

      describe 'adding a third node to the head' do
        before(:each) { linked_list.add_to_head(2) >> 3 }

        it 'should have a new node at head when #add_to_head is called' do
          expect(linked_list.head.val).to eq(3)
        end

        it 'should have the new node at head which should have the old node at next' do
          expect(linked_list.head.next.val).to eq(2)
        end

        it 'should have the old node with the new node at prev' do
          expect(linked_list.head.next.prev.val).to eq(3)
        end

        it 'should return an array of values [3,2,1]' do
          expect(linked_list.return_list_from_head).to eq([3,2,1])
        end
      end
    end
    describe 'adding a node to the tail' do
      before(:each) { linked_list.add_to_tail(2)}

      it 'should have a new node at the tail when #add_to_tail is called' do
        expect(linked_list.last.val).to eq(2)
      end

      it 'should have a head node with the new node a next' do
        expect(linked_list.head.next.val).to eq(2)
      end

      it 'should have the new node at tail with the old node at prev' do
        expect(linked_list.tail.prev.val).to eq(1)
      end

      it 'should return an array of values [1,2]' do
        expect(linked_list.return_list_from_head).to eq([1,2])
      end
      describe 'adding a third node to the tail' do

        before(:each) { linked_list << 3}

        it 'should have a new node at the tail when #add_to_tail is called' do
          expect(linked_list.tail.val).to eq(3)
        end

        it 'should have a head node with the new node at next.next' do
          expect(linked_list.head.next.next.val).to eq(3)
        end

        it 'should have the new node at tail with the original node at prev.prev' do
          expect(linked_list.tail.prev.prev.val).to eq(1)
        end

        it 'should return an array of values [1,2,3]' do
          expect(linked_list.return_list_from_head).to eq([1,2,3])
        end
      end
    end
    describe 'adding a node before a node' do
      before(:each) { linked_list.add_to_tail(2).add_to_tail(4)}

      it 'should insert a new node before the given node' do
        linked_list.add_before(3,2)
        expect(linked_list.print_from_head).to eq('[1] -> 3 -> 2 -> 4')
        expect(linked_list.print_from_tail).to eq('1 <- 3 <- 2 <- [4]')
      end
    end
    describe 'adding a node after a node' do
      before(:each) { linked_list.add_to_tail(2).add_to_tail(4)}

      it 'should insert a new node before the given node' do
        linked_list.add_after(3,2)
        expect(linked_list.print_from_head).to eq('[1] -> 2 -> 3 -> 4')
        expect(linked_list.print_from_tail).to eq('1 <- 2 <- 3 <- [4]')
      end

      it 'should have four nodes' do
        expect(linked_list.count).to eq(3)
      end

      it 'should add a node to tail when the current tail is given as an arg' do
        linked_list.add_after(3,4)
        expect(linked_list.print_from_head).to eq('[1] -> 2 -> 4 -> 3')
      end
    end
  end

  describe 'tail caching' do
    let(:linked_list) { described_class.new(1) }

    it 'should cache the tail after nodes are added' do
      expect(linked_list).to receive(:fetch_tail).exactly(4).times.and_call_original
      linked_list << 2
      linked_list << 3
      linked_list << 4
    end

    it 'should correctly update the tail cache when add_after is called with the tail node' do
      expect(linked_list.tail.val).to eq(1)
      linked_list.add_after(2,1)
      expect(linked_list.tail.val).to eq(2)
      linked_list.add_after(3,2)
      expect(linked_list.tail.val).to eq(3)
    end
  end

  describe 'popping a node off the tail of the list' do
    let(:linked_list) { described_class.new(4).unshift(3).unshift(3).unshift(4)}

    it 'should return the last node when #pop is called' do
      node = linked_list.pop
      expect(node.val).to eq(4)
    end

    it 'should have a list length of 3 after #pop is called' do
      expect(linked_list.length).to eq(4)
      linked_list.pop
      expect(linked_list.length).to eq(3)
    end
  end

  describe 'shifting a node off the tail of the list' do
    let(:linked_list) { described_class.new(1).push(2).push(3).push(4)}

    it 'should return the last node when #pop is called' do
      node = linked_list.shift
      expect(node.val).to eq(1)
    end

    it 'should have a list length of 3 after #pop is called' do
      expect(linked_list.length).to eq(4)
      linked_list.shift
      expect(linked_list.length).to eq(3)
    end
  end

  describe 'working with an empty list' do
    let(:linked_list) { described_class.new }

    it 'should add the first node to the head using #unshift' do
      linked_list.unshift(1)
      expect(linked_list.head.val).to eq(1)
    end

    it 'should add the first node to the head using #push' do
      linked_list.push(1)
      expect(linked_list.head.val).to eq(1)
    end

    it 'should return a #count of 0' do
      expect(linked_list.count).to eq(0)
    end

    it 'should return an empty array for #return_list_from_tail' do
      expect(linked_list.return_list_from_tail).to eq([])
    end

    it 'should not have a tail' do
      expect(linked_list.tail).to_not be
    end

    it 'should not have a head' do
      expect(linked_list.head).to_not be
    end

    it 'should return an empty string for #print_from_head' do
      expect(linked_list.print_from_head).to eq('')
    end

    it 'should return an empty string for #print_from_tail' do
      expect(linked_list.print_from_tail).to eq('')
    end

  end

  describe 'error handling on invalid operations' do
    let(:linked_list) { described_class.new }

    it 'should return Orderly::LinkedList::NodeNotFound when #add_after is called' do
      expect { linked_list.add_after(1,2) }.to raise_error(Orderly::LinkedList::NodeNotFound)
    end

    it 'should return Orderly::LinkedList::NodeNotFound when #add_before is called' do
      expect { linked_list.add_before(1,2) }.to raise_error(Orderly::LinkedList::NodeNotFound)
    end

    it 'should return Orderly::LinkedList::NodeNotFound when #print_from_node is called' do
      expect { linked_list.print_from_node(2) }.to raise_error(Orderly::LinkedList::NodeNotFound)
    end
  end
end
