module Helpdesk
  class Ticket < ActiveRecord::Base
    attr_accessible :assigned_id, :close_date, :desc, :patron_id, :status, :title, :user_id
  end
end
