module Helpdesk
  class Ticket < ActiveRecord::Base

    include Tire::Model::Search
    include Tire::Model::Callbacks
    index_name { "helpdesk-tickets-#{Patron.current_id}" }

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

    mapping do
      indexes :id, index: :not_analyzed
      indexes :title, analyzer: 'snowball', boost: 100
      indexes :desc, analyzer: 'snowball'
      indexes :status, index: :not_analyzed
      indexes :user_id, index: :not_analyzed
      indexes :assigned_id, index: :not_analyzed
      indexes :close_date, type: 'date', index: :not_analyzed
      indexes :created_at, type: 'date', index: :not_analyzed
    end

    def to_indexed_json
      {
        id: id,
        title: title,
        desc: desc,
        status: status,
        user_id: user_id,
        assigned_id: assigned_id,
        close_date: close_date,
        created_at: created_at
      }.to_json
    end
  end
end
