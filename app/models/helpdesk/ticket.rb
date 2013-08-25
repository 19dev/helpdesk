module Helpdesk
  class Ticket < ActiveRecord::Base

    include Tire::Model::Search
    include Tire::Model::Callbacks
    index_name { "helpdesk-tickets-#{Nimbos::Patron.current_id}" }

    belongs_to :user, class_name: "Nimbos::User"
    belongs_to :assigned, class_name: "Nimbos::User"

    has_many   :ticket_actions 
    has_many   :posts, class_name: "Nimbos::Post", as: :target, dependent: :destroy

    attr_accessible :assigned_id, :close_date, :desc, :status, :title

    #validates :reference, presence: { on: :update }, uniqueness: { case_sensitive: false, scope: :patron_id }
    validates :title, presence: true, length: { maximum: 255 }
    validates :user_id, presence: true
    validates :status, presence: true

    default_scope { where(patron_id: Nimbos::Patron.current_id) }
    scope :latest, order("created_at desc")

    before_create :set_initials

    def self.ticket_status
    	%w[open assigned closed]
    end

    def to_s
      reference
    end

    def to_param
      "#{id}-#{title.parameterize}"
    end

    mapping do
      indexes :id, type: :integer, index: :not_analyzed
      indexes :title, analyzer: 'snowball', boost: 100
      indexes :desc, analyzer: 'snowball'
      indexes :status, index: :not_analyzed
      indexes :user do
        indexes :name, analyzer: 'snowball'
        indexes :surname, analyzer: 'snowball'
        indexes :avatar, index: :not_analyzed
      end
      indexes :assigned do
        indexes :name, analyzer: 'snowball'
        indexes :surname, analyzer: 'snowball'
        indexes :avatar, index: :not_analyzed
      end
      indexes :close_date, type: 'date', index: :not_analyzed
      indexes :created_at, type: 'date', index: :not_analyzed
    end

    def to_indexed_json
      #{
      #  id: id,
      #  title: title,
      #  desc: desc,
      #  status: status,
      #  assigned_id: assigned_id,
      #  close_date: close_date,
      #  created_at: created_at,
      #}.to_json(include: { user: { only: [:name, :surname, :avatar_url] } })
      to_json(include: { user: { only: [:name, :surname, :avatar] }, assigned: { only: [:name, :surname, :avatar] } })
    end

private
    def set_initials
      self.reference = Nimbos::Patron.generate_counter("Ticket", nil, nil)
    end
  end
end
