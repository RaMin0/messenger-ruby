module Messenger
  module Parameters
    class Referral
      include Callback

      attr_accessor :ref, :source, :ref_type

      def initialize(ref:, source:, type:)
        @ref = ref
        @source = source
        @ref_type = type
      end
    end
  end
end
