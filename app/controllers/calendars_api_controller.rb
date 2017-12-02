class CalendarsApiController < ApplicationController
  before_action :authenticate, only: [:redirect, :callback, :calendars, :calendar_events, :new_calendar_event]


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

    redirect_to calendar_events_url(:calendar_id => 'primary')
  end


  # fetching calendar events
  def calendar_events
    groups = @current_user.groups.order(:name)
    @alltasks = Task.where(:group => nil)
    # @alltasks = Task.where(:created_by => @current_user.name)
    groups.each do |group|
      @tasks = Task.where(:group => group.name).order(:deadline)
      @alltasks.concat @tasks
      # @alltasks << @tasks
    end

    # @tasks = Task.all
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_event_list = service.list_events(params[:calendar_id])

    # @event_list = service.list_events('primary')

    # refresh authorization
    rescue Google::Apis::AuthorizationError
      if client.expired?
        # client.authorization_uri.fetch_access_token!
        redirect_to redirect_path
        # response = client.fetch_access_token!

        # session[:authorization] = response
      # end
      # if client.invalid?
      #   redirect_to redirect_uri
      # elsif session[:authorization].invalid?
      #   redirect_to redirect_url
      else
        response = client.refresh!
        session[:authorization] = session[:authorization].merge(response)

      end

    retry
  end

  # adding an event from web app to Google Calendar through API
  def new_calendar_event
     taskid = params[:taskid]
     @task = Task.where(:id => taskid).take
     # @tasks = Task.where(:group => "CMPT 300")
     client = Signet::OAuth2::Client.new(client_options)
     client.update!(session[:authorization])

     service = Google::Apis::CalendarV3::CalendarService.new
     service.authorization = client

     today = Date.today
     # @tasks.each do |task|
       # datetime = DateTime.parse(task.deadline.localtime)
     datetime = @task.deadline
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
       summary: @task.title,
       description: @task.description
     })

      service.insert_event('primary', event)
     # end
     # service.insert_event(params[:calendar_id], event)


     redirect_to calendar_events_url(calendar_id: params[:calendar_id])
   end

   def show_calendar_event
     event_id = params[:id]

     client = Signet::OAuth2::Client.new(client_options)
     client.update!(session[:authorization])

     service = Google::Apis::CalendarV3::CalendarService.new
     service.authorization = client

     @calendar_event_list = service.list_events('primary')
     @calendar_event_list.items.each do |event|
       if event.id == event_id
         @show_calendar_event = event
         break
       end
     end

     eventtime = @show_calendar_event.start.date_time.localtime
     eventtimestring = eventtime.to_s(:db)
     eventtimeparsed = DateTime.parse(eventtimestring)
     @formatted_datetime = eventtimeparsed.strftime('%a %b %d, %Y  %I:%M%P')
     @days_till_event = (eventtime - Time.zone.now).to_i / 1.day

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

    def authenticate
      token = session[:current_user_token]
      @user_login = UserLogin.where('token = (?)', token).take
      if @user_login == nil
        respond_to do |format|
          format.html { redirect_to new_user_login_path, notice: '' }
        end
      else
        @current_user = User.where(:email => @user_login.email).take
      end
    end

end
