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

    redirect_to events_url(:calendar_id => 'primary')
  end

  # fetching a list of calendars
  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
  rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  end

  # fetching calendar events
  def events
    @tasks = Task.all
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
    # @event_list = service.list_events('primary')
  end

  # adding an event from web app to Google Calendar through API
  def new_event
     @tasks = Task.where(:group => "CMPT 300")
     client = Signet::OAuth2::Client.new(client_options)
     client.update!(session[:authorization])

     service = Google::Apis::CalendarV3::CalendarService.new
     service.authorization = client

     today = Date.today
     @tasks.each do |task|
       # datetime = DateTime.parse(task.deadline.localtime)
       datetime = task.deadline
       datetimestring = datetime.to_s(:db)
       datetimeparsed = DateTime.parse(datetimestring)
       formatted_datetime = datetimeparsed.strftime('%Y-%m-%dT%H:%M:00-08:00')
       event = Google::Apis::CalendarV3::Event.new({

         start: {
            date_time: formatted_datetime
            # time_zone: 'America/Los_Angeles',
         },
         end: {
            date_time: formatted_datetime
            # time_zone: 'America/Los_Angeles',
         },
       #   start: Google::Apis::CalendarV3::EventDateTime.new(date_time: task.deadline.localtime),
       # end: Google::Apis::CalendarV3::EventDateTime.new(date_time: task.deadline.localtime + 30),
         # summary: params[:summary],
         summary: task.title,
         description: task.description,
         location: 'Burnaby'
         # reminders: {
         #   use_default: false,
         #   overrides: [
         #     {method' => 'email', 'minutes: 24 * 60}
         #   ],
         # },
       })

      service.insert_event('primary', event)
     end
     # service.insert_event(params[:calendar_id], event)


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
