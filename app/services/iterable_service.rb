class IterableService
  include HTTParty
  def self.send_email_notification(email)
    url = ENV['ITERABLE_IO_URL']
    api_key = ENV['ITERABLE_IO_API_KEY']
    email_target_url = "#{url}/api/email/target"
    body = {
      "campaignId": 0,
      "recipientEmail": email,
    }

    event_response = HTTParty.post(email_target_url, body: body.to_json, headers: {
      Authorization: "Bearer #{api_key}", 'Content-Type' => 'application/json'
    })
    return event_response

  end

  def self.web_push_event(event_type,email)
    url = ENV['ITERABLE_IO_URL']
    api_key = ENV['ITERABLE_IO_API_KEY']
    web_push_url = "#{url}/api/events/trackWebPushClick"
    body = {
      "email": email ,
      "messageId": event_type,
    }
    event_response = HTTParty.post(web_push_url, body: body.to_json, headers: {
      Authorization: "Bearer #{api_key}", 'Content-Type' => 'application/json'
    })
    return event_response
  end

end