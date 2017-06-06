require 'spec_helper'

describe LinkedList do
  subject { LinkedList }

  it 'should raise an error on initialization with no arg' do
    expect { subject.new }.to raise_error(ArgumentError)
  end

  it 'should not raise an error on initialization with a string' do
    expect { subject.new('string') }.to_not raise_error
  end

  it 'should not raise an error on initialization with an int' do
    expect { subject.new(1) }.to_not raise_error
  end

  describe 'adding nodes' do

    let(:linked_list) { LinkedList.new(1)}

    describe 'adding a node to the head' do

      it 'should have a node at head when initialized' do
        expect(linked_list.head.val).to eq(1)
      end

      describe 'adding a second node to the head' do
        before(:each) { linked_list.add_to_head(2) }

        it 'should have a new node at head when #add_to_head is called' do
          expect(linked_list.head.val).to eq(2)
        end

        it 'should have the new node at head which should have the old node at next' do
          expect(linked_list.head.next.val).to eq(1)
        end

        it 'should have the old node with the new node at prev' do
          expect(linked_list.head.next.prev.val).to eq(2)
        end

        it 'should return an array of values [2,1]' do
          expect(linked_list.return_list).to eq([2,1])
        end
      end

      describe 'adding a third node to the head' do
        before(:each) { linked_list.add_to_head(2) << 3 }

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
          expect(linked_list.return_list).to eq([3,2,1])
        end
      end
    end
    describe 'adding a node to the tail' do
      before(:each) { linked_list.add_to_tail(2)}

      it 'should have a new node at the tail when #add_to_tail is called' do
        expect(linked_list.tail.val).to eq(2)
      end

      it 'should have a head node with the new node a next' do
        expect(linked_list.head.next.val).to eq(2)
      end

      it 'should have the new node at tail with the old node at prev' do
        expect(linked_list.tail.prev.val).to eq(1)
      end

      it 'should return an array of values [1,2]' do
        expect(linked_list.return_list).to eq([1,2])
      end
      describe 'adding a third node to the tail' do

        before(:each) { linked_list >> 3}

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
          expect(linked_list.return_list).to eq([1,2,3])
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
    end
  end

  describe 'tail caching' do
    it 'should cache the tail after nodes are added' do
      linked_list = LinkedList.new(1)
      expect(linked_list).to receive(:fetch_tail).exactly(4).times.and_call_original
      linked_list >> 2
      linked_list >> 3
      linked_list >> 4
    end
  end
end
