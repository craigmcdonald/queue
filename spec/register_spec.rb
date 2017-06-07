require 'spec_helper'
require 'ostruct'

describe Orderly::Register do

  it 'should accept an object that responds to uuid' do
    expect { described_class.add(OpenStruct.new({uuid: 1})) }
      .to_not raise_error
  end

  it 'should raise an error if object has nil uuid' do
    expect { described_class.add(OpenStruct.new({uuid: nil})) }
      .to raise_error(Orderly::Register::MissingUUID)
  end

  it 'should return an object based on its uuid' do
    described_class.add(OpenStruct.new({uuid: 2}))
    object2 = OpenStruct.new({uuid: 3})
    described_class << object2
    expect(described_class.search(3)).to be(object2)
  end

  it 'should raise ::DupKey when adding a duplicate uuid' do
    described_class.add(OpenStruct.new({uuid: 4}))
    expect { described_class.add(OpenStruct.new({uuid: 4})) }
    .to raise_error(Orderly::Register::DupKey)
  end

  it 'should raise ::KeyNotFound when searching for a key which does not exist' do
    expect { described_class.find(5) }
    .to raise_error(Orderly::Register::KeyNotFound)
  end

  it 'should raise ::KeyNotFound when searching for a deleted key' do
    described_class.add(OpenStruct.new({uuid: 6}))
    expect(described_class.find(6).uuid).to eq(6)
    described_class.delete(6)
    expect { described_class.find(6) }
    .to raise_error(Orderly::Register::KeyNotFound, "6 not found")
  end

  it 'should return 0 when #count is called after #clear!' do
    described_class.add(OpenStruct.new({uuid: 7}))
    expect(described_class.count).to be > 0
    described_class.clear!
    expect(described_class.count).to eq(0)
  end
end
