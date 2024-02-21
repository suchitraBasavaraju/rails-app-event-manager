class IterableService
  include HTTParty

  def self.send_email_notification(email)
    initialize
    email_target_url = "#{@url}/api/email/target"
    body = {
      "campaignId": 0,
      "recipientEmail": email,
    }
    begin
      response = post_request(@api_key, body, email_target_url)
      if response.code == 200
        return "Email Notification sent"
      else
        return "Email Notification failed: #{response.code}"
      end
    rescue StandardError => e
      return "Email Notification failed: #{e.message}"
    end
  end

  def self.track_event(event_type, email)
    initialize
    web_push_url = "#{@url}/api/events/track"
    body = {
      "email": email,
      "eventName": event_type,
    }
    begin
      response = post_request(@api_key, body, web_push_url)
      if response.code == 200
        return "#{event_type} sent"
      else
        return "#{event_type} Failed. Error: #{response.code}"
      end
    rescue StandardError => e
      return "#{event_type} Failed. Error: #{e.message}"
    end
  end

  private

  def self.initialize
    @url = ENV['ITERABLE_IO_URL']
    @api_key = ENV['ITERABLE_IO_API_KEY']
  end

  def self.post_request(api_key, body, target_url)
    response = HTTParty.post(target_url, body: body.to_json, headers: {
      Authorization: " Bearer #{api_key}", 'Content-Type' => 'application/json'
    })

    return response
  end

end