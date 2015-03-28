class TicketMailerWorker

	@queue = :ticket_mailer_queue

	def self.perform(options={})

	  @ticket = Helpdesk::Ticket.unscoped.find_by(id: options["ticket_id"], patron_id: options["patron_id"])

	  Helpdesk::TicketMailer.ticket_created(@ticket).deliver
			
	end
end
