class AddIndexesToHelpdeskTickets < ActiveRecord::Migration
  def change
  	add_index :helpdesk_tickets, :patron_id
  	add_index :helpdesk_tickets, :team_id
  	add_index :helpdesk_tickets, :user_id
  end
end
