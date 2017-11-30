class CalendarsApiController < ApplicationController
  # redirect the user to Google so they can sign in and consent
  # to the access of Google Calendar
  # https://readysteadycode.com/howto-integrate-google-calendar-with-rails
  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end

  # fetching an access token
  # https://readysteadycode.com/howto-integrate-google-calendar-with-rails
  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to calendars_url
  end

  # fetching a list of calendars
  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
  end

  # fetching calendar events
  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end

  # adding an event from web app to Google Calendar through API
  def new_event
     client = Signet::OAuth2::Client.new(client_options)
     client.update!(session[:authorization])

     service = Google::Apis::CalendarV3::CalendarService.new
     service.authorization = client

     today = Date.today

     event = Google::Apis::CalendarV3::Event.new({
       start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
       end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
       summary: 'New event!'
     })

     service.insert_event(params[:calendar_id], event)

     redirect_to events_url(calendar_id: params[:calendar_id])
   end



  private
    # authorizing access to Google Calendar
    # https://readysteadycode.com/howto-integrate-google-calendar-with-rails
    def client_options
      {
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: callback_url
      }
    end
end
