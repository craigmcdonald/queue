module Orderly

  class Register

    DupKey = Class.new(ArgumentError)
    KeyNotFound = Class.new(KeyError)
    MissingUUID = Class.new(ArgumentError)

    @@register = {}
    @mutex = Mutex.new

    class << self

      def add(resource)
        @mutex.synchronize do
          check_for_dup_or_missing_uuid(resource)
          @@register[resource.uuid] = resource
        end
      end
      alias :<< :add

      def search(uuid)
        @mutex.synchronize do
          check_for_missing_key(uuid)
          @@register[uuid]
        end
      end
      alias :find :search

      def delete(uuid)
        @mutex.synchronize do
          check_for_missing_key(uuid)
          @@register[uuid] = nil
        end
      end

      def clear!
        @mutex.synchronize do
          @@register.each_key { |k, _| @@register.delete(k) }
        end
      end

      def count
        @mutex.synchronize do
          @@register.keys.count
        end
      end

      private

      def check_for_dup_or_missing_uuid(resource)
        raise MissingUUID.new("Resource does not have a uuid") if
          !resource.respond_to?(:uuid) || !resource.uuid
        raise DupKey.new("#{resource.uuid} is already present") if
          @@register[resource.uuid]
      end

      def check_for_missing_key(uuid)
        raise KeyNotFound.new("#{uuid} not found") unless
          @@register[uuid]
      end
    end
  end
end
