class AddIndexesToHelpdeskTeams < ActiveRecord::Migration
  def change
  	add_index :helpdesk_teams, :patron_id
  end
end
