class IterableService
  include HTTParty
  def self.send_email_notification(body)
    raise "Iterable API key is missing" unless @api_key
    response = post('/api/email/target', body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => 'Bearer ' + @api_key })
    response.parsed_response
    return 'Event B created! for user id: ' + body[:recipientUserId]
  end

  def self.web_push_event(event_type,email)
    url = ENV['ITERABLE_IO_URL']
    api_key = ENV['ITERABLE_IO_API_KEY']
    iterable_io_url = "#{url}/api/events/trackWebPushClick"
    body = {
      "email": email ,
      "messageId": event_type,
    }
    event_response = HTTParty.post(iterable_io_url, body: body.to_json, headers: {
      Authorization: "Bearer #{api_key}", 'Content-Type' => 'application/json'
    })
    return event_response
  end

end