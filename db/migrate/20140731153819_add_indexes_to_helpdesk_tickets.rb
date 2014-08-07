class AddIndexesToHelpdeskTickets < ActiveRecord::Migration
  def change
  	add_index :helpdesk_tickets, :patron_id
  	add_index :helpdesk_tickets, [:title, :patron_id]
  end
end
