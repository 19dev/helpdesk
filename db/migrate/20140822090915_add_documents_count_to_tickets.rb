class AddDocumentsCountToTickets < ActiveRecord::Migration
  def change
    add_column :helpdesk_tickets, :documents_count, :integer, default: 0
  end
end
