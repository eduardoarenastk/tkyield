class EventsController < DashboardController
	before_action :get_schedule, only: [:create, :update, :destroy]
	before_action :get_events, only: :create
	def index
	end

	def new
	end

	def create
		event_log = EventLog.new
		event_log.set_event_data(event_params[:inTime], event_params[:outTime], params[:schedule_id], current_user.id, 
														Chronic.parse('monday', :context => :past).to_date  + params[:event][:day_of_week].to_i,
														params[:event][:launch])
		new_event = Event.new(event_params)
		new_event.schedule_id = params[:schedule_id]
		new_event.day_of_week = params[:event][:day_of_week].to_i
		new_event.last_event_log = event_log.id
		if new_event.errors.blank?
			new_event.save
		end
	end

	def edit
	end

	def update
		@current_event = Event.find(params[:id])
		last_event_log = EventLog.find(@current_event.last_event_log)
		last_event_log.edited = false
		last_event_log.save
		last_day = @current_event.day_of_week.to_date.wday
		event_log = EventLog.new
		event_log.set_event_data(params[:start_event], params[:finish_event], params[:schedule_id], current_user.id,
			                      Chronic.parse('monday', :context => :past).to_date + last_day - 1,
			                      false)
		#event_log.set_launch(params[:event][:launch]), por ahora false
		@current_event.update_attributes({:name=>params[:name_event], :inTime=>params[:start_event], :outTime=>params[:finish_event], :last_event_log=>event_log.id})
	end

	def destroy
	end

	private
		def event_params
			params.require(:event).permit(:name, :inTime, :outTime)
		end
		def get_events
			@events = Event.all
		end
		def get_schedule
			@schedule = Schedule.find(params[:schedule_id])			
		end
end