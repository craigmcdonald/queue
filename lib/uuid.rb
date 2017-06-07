require 'securerandom'

['uuid_counter','uuid_limit'].each do |attribute_name|
  Thread.send('define_method',"#{attribute_name}=".to_sym) do |val|
    instance_variable_set("@" + attribute_name.to_s, val)
  end
  Thread.send('define_method', attribute_name.to_sym) {
    instance_variable_get("@" + attribute_name.to_s)
  }
end

module Orderly

  class UUID

    PREFIX = SecureRandom.hex(9).match(/(.{8})(.{4})(.{3})(.{3})/)
      .to_a
      .drop_while.with_index { |_,i| i < 1}
      .map.with_index { |a,i| i > 1 ? "#{rand(9)}#{a}" : a }
      .join('-')
      .freeze
    BLOCK =  0x10000

    @counter = 0
    @mutex = Mutex.new

    class << self

      def thread
        @thread ||= Thread.current
      end

      def increment_counter
        @mutex.synchronize do
          base = @counter
          @counter += BLOCK
          thread.uuid_counter = base
          thread.uuid_limit = @counter - 1
        end
      end

      def generate
        increment_counter unless thread.uuid_limit
        counter = thread.uuid_counter
        if thread.uuid_counter >= thread.uuid_limit
          thread.uuid_counter = thread.uuid_limit = nil
        else
          thread.uuid_counter += 1
        end
        "#{PREFIX}-#{format('%012x', counter)}".freeze
      end

    end
  end
end
