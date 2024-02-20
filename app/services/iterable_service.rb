class IterableService
  include HTTParty

  base_uri ENV['ITERABLE_IO_URL']

  def self.send_email_notification(body)
    api_key = ENV['ITERABLE_IO_API_KEY']
    raise "Iterable API key is missing" unless api_key
    response = post('/api/email/target', body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => 'Bearer ' + api_key })
    response.parsed_response
    return 'Event B created! for user id: ' + body[:recipientUserId]
  end

end