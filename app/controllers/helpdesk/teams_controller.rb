require_dependency "helpdesk/application_controller"

module Helpdesk
  class TeamsController < ApplicationController
    before_filter :require_login
    def new
      @team= Team.new
    end

    def edit
      @team= Team.find(params[:id])
    end

    def show
      @team = Team.find(params[:id])
    end

    def index
    	@teams = Team.all
      @team  = Team.new
    end

    def create
      @team = Team.new(team_params)
      @team.user_id = current_user.id
      respond_to do |format|
        if @team.save
          flash[:notice] = t("teams.message.created")
          format.html { redirect_to @team }
          format.json { render json: @team, status: :created, location: @team }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @team.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      @team = Team.find(params[:id])
      @team.user_id = current_user.id 
      respond_to do |format|
        if @team.update_attributes(team_params)
          format.html { redirect_to @team, notice: t('teams.message.team_action_updated') }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @team = Team.find(params[:id])
      @team.destroy
      flash[:notice] = t("teams.message.deleted")

      respond_to do |format|
        format.html { redirect_to teams_url }
        format.json { head :ok }
        format.js
      end
    end

    private
    def team_params
      params.require(:team).permit(:title, :email )
    end

  end
end
