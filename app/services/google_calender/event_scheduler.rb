require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

module GoogleCalender
  class EventScheduler
    attr_accessor :event, :user, :client

    CALENDER_ID = 'primary'

    def initialize(user, event)
      @user = user
      @event = event
      @client = build_client
    end

    def register_event
      calender_event = Google::Apis::CalendarV3::Event.new(
        summary: event.title,
        location: event.location,
        description: event.description,
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: event.start_at.to_datetime.rfc3339,
          time_zone: 'America/New_York'
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: event.end_at.to_datetime.rfc3339,
          time_zone: 'America/New_York'
        ),
        attendees: [
          Google::Apis::CalendarV3::EventAttendee.new(
            email: user.email
          )
        ]
      )

      result = client.insert_event(CALENDER_ID, calender_event)
      event.update!(gc_event_id: result.id, gc_link: result.html_link)
    end

    def update_event
      calender_event = client.get_event('primary', event.gc_event_id)
      return if calender_event.id.nil?

      calender_event.summary = event.title
      calender_event.location = event.location
      calender_event.description = event.description
      calender_event.start = Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event.start_at.to_datetime.rfc3339,
        time_zone: 'America/New_York'
      )
      calender_event.end = Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event.end_at.to_datetime.rfc3339,
        time_zone: 'America/New_York'
      )

      result = client.update_event('primary', calender_event.id, calender_event)
      print result.updated
    end

    def delete_event
      client.delete_event('primary', event.gc_event_id)
    rescue StandardError => e
      puts "Error occured for deleting event #{event.id}"
      puts e
    end

    private

    def build_client
      return unless user.present? && user.access_token.present? && user.refresh_token.present?

      client = Google::Apis::CalendarV3::CalendarService.new
      secrets = Google::APIClient::ClientSecrets.new({
                                                       'web' => {
                                                         'access_token' => user.access_token,
                                                         'refresh_token' => user.refresh_token,
                                                         'client_id' => Rails.application.credentials.dig(
                                                           :google_oauth2, :client_id
                                                         ),
                                                         'client_secret' => Rails.application.credentials.dig(
                                                           :google_oauth2, :client_secret
                                                         )
                                                       }
                                                     })

      client.authorization = secrets.to_authorization
      regenerate_token_if_expired?(client)

      client
    end

    def regenerate_token_if_expired?(client)
      return unless user.token_expired?

      begin
        client.authorization.refresh!
        user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      rescue StandardError => e
        puts "Error occured while refershing token #{e}"
      end
    end
  end
end
