class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create_event_a
    user = current_user
    Event.create(name: "Event A", user_id: user.id, event_type: "A")
    begin
      response = IterableService.track_event("Event A", current_user.email)
      flash[:success] = response
    rescue StandardError => e
      flash[:error] = "#{e.message}"
    end
    redirect_to root_path
  end

  # Every user fetch all of events for user
  # for every event type, send one email

  # Event a - Event b events. one email for instance type for user : send email
  # Response:
  # {
  #   "events": [
  #     { name: "Event A", user_id: 1, event_type: "A" },
  #     { name: "Event B", user_id: 1, event_type: "B" },
  #   ]
  # }
  def send_email_for_events
    user = current_user
    response = IterableService.get_events(current_user.id)
    event_types = response[:events].pluck(:event_type).uniq

    event_types.each do |event_type|
      response_notification = IterableService.send_email_notification(current_user.email)
      combined_response = "#{response_notification}"
      flash[:success] = "#{combined_response}"
    end
    redirect_to root_path
  end

  def create_event_b
    user = current_user
    Event.create(name: "Event B", user_id: user.id, event_type: "B")
    begin
      response_event_b = IterableService.track_event("Event B", current_user.email)
      response_notification = IterableService.send_email_notification(current_user.email)
      combined_response = "#{response_event_b} - #{response_notification}"
      flash[:success] = combined_response
    rescue StandardError => e
      flash[:error] = "#{e.message}"
    end
    redirect_to root_path
  end

end
