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
        eval(@type.to_s)
      end

      def default
        { type: @type, title: @title }
      end

      def web_url
        default.merge(url: @value).merge(options.slice(
          :webview_height_ratio, :webview_share_button, :messenger_extensions, :fallback_url
        ))
      end

      def postback
        default.merge(payload: @value)
      end

      def phone_number
        default.merge(payload: @value)
      end

      def element_share
        default.slice(:type)
      end
    end
  end
end
