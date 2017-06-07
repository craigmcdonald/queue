require 'spec_helper'
require 'ostruct'

describe Orderly::Store do

  class Orderly::Store
    if ENV['ORDERLY_ENV'] = 'test'
      require 'erb'
      @@dir = YAML.load(ERB.new(File
        .read(ENV['ORDERLY_TEST_CONF']))
        .result(binding))['store_path']
    end
  end

  after { delete_file }

  it 'should save an object to disk' do
    obj = OpenStruct.new({a: 1 })
    described_class.save(obj)
    expect(Marshal.load(open_file)).to eq(obj)
  end

  def delete_file
    File.delete(file)
  end

  def open_file
    File.read(file)
  end

  def file
    YAML.load(ERB.new(File
      .read(ENV['ORDERLY_TEST_CONF']))
      .result(binding))['store_path'] + '/1.dat'
  end

end
