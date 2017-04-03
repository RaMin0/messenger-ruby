module Messenger
  module Elements
    class Button
      attr_accessor :type, :title, :value

      def initialize(type:, title:, value:)
        @type  = type
        @title = title
        @value = value
      end

      def build
        { type: @type, title: @title }.merge! eval(@type.to_s)
      end

      def web_url
        { url: @value }
      end

      def postback
        { payload: @value }
      end

      def phone_number
        { payload: @value }
      end
    end
  end
end
