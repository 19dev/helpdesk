class AddPriorityToHelpdeskTickets < ActiveRecord::Migration
  def change
  	change_table :helpdesk_tickets do |t|
      t.string  :priority, limit: 15
    end
  end
end
