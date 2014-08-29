module Helpdesk
  class TicketMailer < ActionMailer::Base
    #default from: "from@example.com"

	  def ticket_created(ticket)
	    @ticket = ticket
	    @team   = @ticket.team
	    @user   = @ticket.user
	    mail(from: @user.email, to: @team.email, subject: 'New Ticket created for your team, check it now')
	  end

	  def ticket_closed(ticket)
	  	@ticket = ticket
	    @team   = @ticket.team
	    @user   = @ticket.user
	    mail(from: @team.email, to: @user.email, subject: 'Your ticket has been closed, check it now')
	  end
  end
end
