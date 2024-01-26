class EventsController < ApplicationController
  before_action :load_event, only: %i[destroy edit update]

  def index
    @events = Event.order(updated_at: :desc)

    if params[:start_at].present? & params[:end_at].present?
      start_at = Time.zone.parse(params[:start_at]).beginning_of_day
      end_at = Time.zone.parse(params[:end_at]).end_of_day

      @events = Event.searched_by(start_at, end_at).order(updated_at: :desc)
    else
      @events = Event.order(updated_at: :desc)
    end
  end

  def new
    @event = Event.new
  end

  def create
    event = Event.new(event_params)
    if event.save

      GoogleCalender::EventScheduler.new(current_user, event).register_event

      flash[:success] = t(:successfully_created, scope: :event)
      redirect_to events_url
    else
      flash[:error] = t(:something_went_wrong, scope: :event)
      render :new
    end
  end

  def update
    if @event.update(event_params)

      GoogleCalender::EventScheduler.new(current_user, @event).update_event

      flash[:notice] = t(:successfully_updated, scope: :event)
      redirect_to events_path
    else
      flash[:error] = @event.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    GoogleCalender::EventScheduler.new(current_user, @event).delete_event

    @event.destroy
    redirect_to events_path, notice: 'Event was successfully destroyed.'
  end

  private

  def load_event
    @event = Event.find_by(id: params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :start_at, :end_at)
  end
end
