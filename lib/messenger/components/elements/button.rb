module Messenger
  module Elements
    class Button
      attr_accessor :type, :title, :value
      attr_accessor :options

      def initialize(type:, title:, value:, **options)
        @type    = type
        @title   = title
        @value   = value
        @options = options
      end

      def build
        { type: @type, title: @title }.merge! eval(@type.to_s)
      end

      def web_url
        { url: @value }.merge(options.slice(
          :webview_height_ratio, :webview_share_button, :messenger_extensions, :fallback_url
        ))
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
