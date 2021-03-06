module Reports
  class ProjectsController < DashboardController
    before_action :set_time
    before_action :set_project
    add_breadcrumb "Dashboard", :dashboard_path 
    add_breadcrumb "Reports", :reports_list_path 
    add_breadcrumb "Timesheet Report", :reports_dash_path
    
    def show
      add_breadcrumb "Projects", :reports_project_path
      @users = current_account.users.between_dates_and_project(@beginning, @end, @project).order("first_name, last_name")
      @tasks = current_account.tasks.between_dates_and_project(@beginning, @end, @project).order("name")
      respond_to do |format|
        format.html
        format.js
      end
    end

    def project_excel
      @timesheets = Timesheet.find_by_dates_and_project(@beginning, @end, @project)
      respond_to do |format|
        format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='Project #{@project.name} Report.xlsx'"}
      end
    end

    private 

    def set_project
      @project = current_account.projects.find(params[:id] || params[:project_id])
    end

    def set_time
      @today = Time.zone.now.to_date
      @day_selected = ( params[:date] ) ? DateTime.parse(params[:date]) : @today
      @type = (params[:type]) ? params[:type] : "Weekly"
      @tab = (params[:tab]) ? params[:tab] : "tab1"
      if @type == "Weekly"
        @beginning = @day_selected.at_beginning_of_week 
        @end = @day_selected.at_end_of_week
      elsif @type == "Monthly"
        @beginning = @day_selected.at_beginning_of_month
        @end = @day_selected.at_end_of_month
      end
    end
  end
end