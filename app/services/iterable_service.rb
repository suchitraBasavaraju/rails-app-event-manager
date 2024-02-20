class IterableService
  include HTTParty

  def initialize(url, api_key)
    @url = url
    @api_key = api_key
  end

  def send_email_notification(email)
    email_target_url = "#{@url}/api/email/target"
    body = {
      "campaignId": 0,
      "recipientEmail": email,
    }
    post_request(@api_key, body, email_target_url)
  end

  def web_push_event(event_type, email)
    web_push_url = "#{@url}/api/events/trackWebPushClick"
    body = {
      "email": email,
      "messageId": event_type,
    }
    post_request(@api_key, body, web_push_url)
  end

  private

  def post_request(api_key, body, email_target_url)
    HTTParty.post(email_target_url, body: body.to_json, headers: {
      Authorization: "Bearer #{api_key}", 'Content-Type' => 'application/json'
    })
  end

end