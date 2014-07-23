class AddWorkTimeToHelpdeskTickets < ActiveRecord::Migration
  def change
  	change_table :helpdesk_tickets do |t|
      t.decimal  :work_time, default: 0
    end
  end
end
