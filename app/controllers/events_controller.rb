class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create_event_a
    user = current_user
    Event.create(name: "Event A", user_id: user.id, event_type: "A")

    url = ENV['ITERABLE_IO_URL']
    api_key = ENV['ITERABLE_IO_API_KEY']
    iterable_io_url = "#{url}/api/events/trackWebPushClick"
    body = {
      "email": current_user.email,
      "messageId": "Event A",
    }
    begin
      event_a_response = HTTParty.post(iterable_io_url, body: body.to_json, headers: {
        Authorization: "Bearer #{api_key}", 'Content-Type' => 'application/json'
      })

      render json: { message: event_a_response }, status: :ok

    rescue HTTParty::Error, StandardError => e
      render json: { error: "HTTP POST request to Iterable IO failed. #{e.message}" }, status: :unprocessable_entity
    end
  end

  def create_event_b
    user = current_user
    Event.create(name: "Event B", user_id: user.id, event_type: "B")
    flash[:success] = 'Event B created!'
    redirect_to root_path
  end

  def send_email_notifications
    responses = []
    begin
      events_b = Event.where(event_type: 'B')
      events_b.each do |event|
        body = {
          campaignId: 0,
          recipientEmail: "string",
          recipientUserId: event.user_id.to_s,
          dataFields: { favoriteColor: "red" },
          sendAt: "string",
          allowRepeatMarketingSends: true,
          metadata: {}
        }
        response = IterableService.send_email_notification(body)
        responses << response
      end
      flash[:success] = responses
    rescue StandardError => e
      flash[:error] = "Error sending email notifications: #{e.message}"
    ensure
      redirect_to root_path
    end
  end
end
