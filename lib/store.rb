require 'yaml'

module Orderly

  class Store

    @@dir = ENV['ORDERLY_STORE_DIR']
    
    class << self

      def save(obj)
        File.open("#{@@dir}/1.dat", 'wb') { |f| Marshal.dump(obj,f) }
      end
    end

  end

end
