class TicketMailerWorker

	@queue = :ticket_mailer_queue

	def self.perform(ticket_id)

	  ticket = Helpdesk::Ticket.find(ticket_id)

	  Helpdesk::TicketMailer.ticket_created(ticket).deliver
			
	end
end
