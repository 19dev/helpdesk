module Helpdesk
  class Ticket < ActiveRecord::Base

    attr_accessible :assigned_id, :close_date, :desc, :status, :title

    validates :title, presence: true
  end
end
