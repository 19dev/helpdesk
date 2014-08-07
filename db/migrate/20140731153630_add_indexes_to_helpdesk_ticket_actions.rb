class AddIndexesToHelpdeskTicketActions < ActiveRecord::Migration
  def change
  	add_index :helpdesk_ticket_actions, :ticket_id
  end
end
