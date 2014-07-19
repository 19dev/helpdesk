module Helpdesk
  class TicketAction < ActiveRecord::Base

    belongs_to :user, class_name: Helpdesk.user_class
    belongs_to :ticket

    validates :action_code, presence: true, length: { maximum: 30 }
    validates :assigned, length: { maximum: 100 }
    validates_associated :ticket
    
  end
end
