require_dependency "helpdesk/application_controller"

module Helpdesk
  class TicketsController < ApplicationController
    
    before_filter :require_login

    def index
      @tickets = Ticket.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @tickets }
      end
    end
  
    def show
      @ticket = Ticket.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @ticket }
      end
    end
  
    def new
      @ticket = Ticket.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @ticket }
      end
    end
  
    def edit
      @ticket = Ticket.find(params[:id])
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
      @ticket = Ticket.new(params[:ticket])
      @ticket.user_id = current_user.id
      @ticket.status = "open"
 
      respond_to do |format|
        if @ticket.save
          format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
          format.json { render json: @ticket, status: :created, location: @ticket }
        else
          format.html { render action: "new" }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def update
      @ticket = Ticket.find(params[:id])
  
      respond_to do |format|
        if @ticket.update_attributes(params[:ticket])
          format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @ticket = Ticket.find(params[:id])
      @ticket.destroy
  
      respond_to do |format|
        format.html { redirect_to tickets_url }
        format.json { head :no_content }
      end
    end
  end
end
