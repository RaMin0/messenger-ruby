require 'rest-client'

module Messenger
  class MessengerController < ActionController::Base
    def validate
      if verify_token_valid? && access_token_valid?
        render json: params["hub.challenge"]
      elsif !verify_token_valid?
        render json: 'Invalid verify token'
      else
        render json: 'Invalid page access token'
      end
    end

    def subscribe
      render json: activate_bot
    rescue RestClient::BadRequest
      render json: 'Invalid page access token'
    end

    protected

    def messenger_config
      Messenger.config
    end

    private

    def app_location
      "https://graph.facebook.com/v2.6/me/subscribed_apps?access_token=#{messenger_config.page_access_token}"
    end

    def activate_bot
      RestClient.post(app_location, nil)
    end

    def access_token_valid?
      JSON.parse(RestClient.get(app_location)).key?('data')
    rescue RestClient::BadRequest
      return false
    end

    def verify_token_valid?
      params["hub.verify_token"] == messenger_config.verify_token
    end

    def fb_params
      safe_params = params.permit(:object,
                                  entry: [
                                      :id,
                                      :time,
                                      messaging: [
                                        { sender: :id },
                                        :timestamp,
                                        { recipient: :id },
                                        message:
                                          [
                                            :mid,
                                            :seq,
                                            { sticker: :id },
                                            :text,
                                            { attachments: [
                                              :type,
                                              :url,
                                              :title,
                                              payload: [
                                                :url,
                                                coordinates: [
                                                :lat, :long
                                              ] ]
                                            ] },
                                            { quick_reply: :payload },
                                            :is_echo,
                                            { app: :id },
                                            :metadata
                                          ],
                                        read: [
                                          :watermark,
                                          :seq
                                        ],
                                        postback: [
                                          :payload, referral: [
                                            :ref, :source, :type
                                          ]
                                        ],
                                        optin: :ref,
                                        delivery: [
                                          { mids: [] },
                                          :watermark,
                                          :seq
                                        ],
                                        account_linking: [
                                          :status, :authorization_code
                                        ],
                                        referral: [
                                          :ref, :source, :type
                                        ]
                                      ]])
      Params.new(safe_params)
    end
  end
end
