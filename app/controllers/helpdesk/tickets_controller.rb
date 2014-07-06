require_dependency "helpdesk/application_controller"

module Helpdesk
  class TicketsController < ApplicationController
    
    before_filter :require_login
    before_filter(:only => [:index]) { |c| c.set_tab "helpdesknavigator" if params[:home].present? }

    def index
      @tickets = Helpdesk::Ticket.order("created_at desc").page(params[:page]).per(10)
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @tickets }
      end
    end
  
    def show
      @ticket = Helpdesk::Ticket.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @ticket }
      end
    end
  
    def new
      @ticket = Helpdesk::Ticket.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @ticket }
      end
    end
  
    def edit
      @ticket = Helpdesk::Ticket.find(params[:id])

      respond_to do |format|
        if params[:nolayout]
          format.html { render partial: 'modal_form', locals: { ticket: @ticket } }
        else
          format.html # edit.html.erb
        end
        format.json { render json: @ticket }
      end
    end
  
    def create
      @ticket = Helpdesk::Ticket.new(ticket_params)
      @ticket.user_id = current_user.id
      @ticket.status = "open"
 
      respond_to do |format|
        if @ticket.save
          create_action("created")
          format.html { redirect_to @ticket, notice: t('tickets.message.ticket_created') }
          format.json { render json: @ticket, status: :created, location: @ticket }
        else
          format.html { render action: "new" }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def update
      @ticket = Helpdesk::Ticket.find(params[:id])
      @updatable = true
      check_for_update
      if @updatable
        #ticket status is changing
        if params[:ticket][:status].present? && (@ticket.status != params[:ticket][:status])
          change_status
        end

        #first time ticket is assigning to someone
        if params[:ticket][:assigned_id].present? && (@ticket.assigned_id != params[:ticket][:assigned_id])
          assign_ticket
        end

        respond_to do |format|
          if @ticket.update_attributes(ticket_params)
            flash[:notice] = t('tickets.message.ticket_updated')
            format.html { redirect_to @ticket }
            format.json { head :no_content }
            format.js   { }
          else
            format.html { render action: "edit" }
            format.json { render json: @ticket.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { render action: "edit" }
          #TODO burada ticket.errors'e flash[:error] eklenmeli
          #format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @ticket = Helpdesk::Ticket.find(params[:id])
      @ticket.destroy
  
      respond_to do |format|
        format.html { redirect_to tickets_url }
        format.json { head :no_content }
      end
    end

    private
    def check_for_update
      if (params[:ticket][:status] != "open" && @ticket.status == "closed")
        @updatable = false
        flash[:error] = "Ticket is closed, can't update."
      end
    end

    def change_status
      #ticket has been closing
      if params[:ticket][:status] == "closed"
        close_ticket
      end

      #ticket has been re opening
      if params[:ticket][:status] == "open"
        if @ticket.status == "closed"
          reopen_ticket
        end
      end
    end

    def close_ticket
      @ticket.close_date = Date.today
      create_action("closed")
    end

    def reopen_ticket
      unless @ticket.assigned_id.nil?
        params[:ticket][:status] = "assigned"
      end
      @ticket.close_date = nil
      create_action("reopened")
    end

    def assign_ticket
      @ticket.status = "assigned"
      if params[:ticket][:assigned_id] != current_user.id
        @assigned_user = Nimbos::User.find(params[:ticket][:assigned_id])
        create_action("assigned", @assigned_user.to_s)
      else
        create_action("self_assigned")
      end
    end

    def create_action(actionCode, assignedUser=nil)
      @action      = @ticket.ticket_actions.new(action_code: actionCode, assigned: assignedUser)
      @action.user = current_user
      @action.save!
    end

    def ticket_params
      params.require(:ticket).permit(:assigned_id, :close_date, :desc, :status, :title, :team_id)
    end

  end
end
