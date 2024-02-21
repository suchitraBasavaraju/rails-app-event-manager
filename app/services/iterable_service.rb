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
        puts "Email sent successfully!"
      else
        handle_failed_email_send(response)
      end

    rescue StandardError => e
      puts "Error sending email: #{e.message}"
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
        puts "#{event_type} created"
      else
        handle_event_creation_failure(response)
      end
    rescue StandardError => e
      puts "Error Event creation: #{e.message} "
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

  def self.handle_failed_email_send(response)
    puts " response.status : #{response.code}"
  end

  def self.handle_event_creation_failure(response)
    puts "API Request failed response.status : #{response.code} "
  end
end