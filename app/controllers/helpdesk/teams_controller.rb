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
          format.html { redirect_to @team, notice: t("simple_form.messages.default.created", model: Helpdesk::Team.model_name.human) }
          format.json { render json: @team, status: :created, location: @team }
          format.js { flash.now[:notice] = t("simple_form.messages.default.created", model: Helpdesk::Team.model_name.human) }
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
          format.html { redirect_to @team, notice: t("simple_form.messages.default.updated", model: Helpdesk::Team.model_name.human) }
          format.json { head :no_content }
          format.js { flash.now[:notice] = t("simple_form.messages.default.updated", model: Helpdesk::Team.model_name.human) }
        else
          format.html { render action: "edit" }
          format.json { render json: @team.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def destroy
      @team = Team.find(params[:id])
      @team.destroy

      respond_to do |format|
        format.html { redirect_to teams_url, notice: t("simple_form.messages.default.deleted", model: Helpdesk::Team.model_name.human) }
        format.json { head :ok }
        format.js { flash[:notice] = t("simple_form.messages.default.deleted", model: Helpdesk::Team.model_name.human) }
      end
    end

    private
    def team_params
      params.require(:team).permit(:title, :email )
    end

  end
end
