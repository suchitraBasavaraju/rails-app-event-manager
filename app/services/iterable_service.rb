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
    begin
      response = post_request(@api_key, body, email_target_url)
      if response.code == 200
        puts "Email sent successfully!"
      else
        handle_failed_email_send(response)
      end

    rescue StandardError => e
      puts "Error sending email: #{e.message}"
    end
  end

  def web_push_event(event_type, email)
    web_push_url = "#{@url}/api/events/track"
    body = {
      "email": email,
      "eventName": event_type,
    }
    begin
      response = post_request(@api_key, body, web_push_url)
      if response.code == 200
        puts "#{event_type} created"
      else
        handle_event_creation_failure(response)
      end
    rescue StandardError => e
      puts "Error Event creation: #{e.message} "
    end
  end

  private

  def post_request(api_key, body, target_url)
    response = HTTParty.post(target_url, body: body.to_json, headers: {
      Authorization: " Bearer #{api_key}", 'Content-Type' => 'application/json'
    })

    return response
  end

  def handle_failed_email_send(response)
    puts " response.status : #{response.code}"
  end

  def handle_event_creation_failure(response)
    puts "API Request failed response.status : #{response.code} "
  end
end