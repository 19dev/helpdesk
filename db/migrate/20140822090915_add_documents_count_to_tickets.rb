class AddDocumentsCountToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :documents_count, :integer, default: 0
  end
end
