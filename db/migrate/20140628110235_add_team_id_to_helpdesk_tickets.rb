class AddTeamIdToHelpdeskTickets < ActiveRecord::Migration
  def change
  	change_table :helpdesk_tickets do |t|
     	t.integer  :team_id
     end
  end
end
