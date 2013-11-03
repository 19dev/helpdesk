module Helpdesk
  class TicketAction < ActiveRecord::Base
    belongs_to :user, class_name: Assetim.user_class
    belongs_to :ticket

    #attr_accessible :action_code, :assigned, :user_id
  end
end
