class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create_event_a
    user = current_user
    Event.create(name: "Event A", user_id: user.id, event_type: "A")

    event_a_response = IterableService.web_push_event("Event A", current_user.email)

    flash[:success] = "event A created"
    render json: { message: "event A created" }, status: :ok

  end

  def create_event_b
    user = current_user
    Event.create(name: "Event B", user_id: user.id, event_type: "B")

    event_a_response = IterableService.web_push_event("Event B", current_user.email)
    send_email_response = IterableService.send_email_notification(current_user.email)

    flash[:success] = "event B created"
    render json: { message: "event A created" }, status: :ok
  end

end
