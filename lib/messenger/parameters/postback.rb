module Messenger
  module Parameters
    class Postback
      include Callback

      attr_accessor :payload, :referral

      def initialize(payload:, referral: nil)
        @payload  = payload
        @referral = build_referral(referral) if referral.present?
      end

      def build_referral(referral)
        Referral.new(referral.transform_keys(&:to_sym))
      end
    end
  end
end
