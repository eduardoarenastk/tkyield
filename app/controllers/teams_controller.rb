class TeamsController < DashboardController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :collaborators]
  add_breadcrumb "Dashboard", :dashboard_path
  add_breadcrumb "Tasks", :teams_path
  
  # GET /teams
  # GET /teams.json
  def index
    @teams = current_account.teams.order("name ASC")
  end

  def collaborators
    @collaborators = @team.nil? ? User.order("first_name, last_name") : @team.users.order("first_name, last_name")
  end
  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    add_breadcrumb "Edit", :edit_team_path
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.account = current_account
    respond_to do |format|
      if @team.save
        format.html { redirect_to teams_path, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = current_account.teams.find(params[:id]) unless params[:id].blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end
end
