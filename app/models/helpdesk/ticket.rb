module Helpdesk
  class Ticket < ActiveRecord::Base

    belongs_to :user, class_name: Assetim.user_class
    belongs_to :assigned, class_name: Assetim.user_class

    has_many :posts, as: :target, dependent: :destroy

    attr_accessible :assigned_id, :close_date, :desc, :status, :title

    validates :title, presence: true, length: { maximum: 255 }
    validates :user_id, presence: true
    validates :status, presence: true

    default_scope { where(patron_id: Patron.current_id) }

    def self.ticket_status
    	%w[open assigned closed]
    end

    def to_param
      "#{id}-#{title.parameterize}"
    end
  end
end
