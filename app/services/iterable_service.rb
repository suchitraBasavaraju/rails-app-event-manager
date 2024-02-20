class IterableService
  include HTTParty

  base_uri 'https://api.iterable.com/api'

  api_key = "api_key"

  def self.send_email_notification(user_email, subject, body)
    return 'Event B created! for user id: ' + user_email
    # response = post('/sendEmail', body: { apiKey: api_key, to: user_email, subject: subject, body: body }.to_json, headers: { 'Content-Type' => 'application/json' })
    # Handle the response as needed
    # You may want to check if the response is successful and handle errors appropriately
    # response.parsed_response
  end
end