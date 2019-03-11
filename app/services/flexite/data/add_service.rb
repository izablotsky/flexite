module Flexite
  module Data
    class AddService
      include SaveMethods

      def initialize(parent, hash)
        @parent = parent
        @hash = hash
      end

      def call
        if @parent.is_a?(Flexite::Config)
          save_hash_value(@parent, @hash)
        else
          save_root(@parent, @hash)
        end
      end
    end
  end
end
