module Helpdesk
  class Ticket < ActiveRecord::Base

    include Tire::Model::Search
    include Tire::Model::Callbacks

    belongs_to :user, class_name: "Nimbos::User"
    belongs_to :assigned, class_name: "Nimbos::User"

    has_many   :ticket_actions, dependent: :destroy
    has_many   :discussions, class_name: "Nimbos::Discussion", as: :target, dependent: :destroy

    #validates :reference, presence: { on: :update }, uniqueness: { case_sensitive: false, scope: :patron_id }
    validates :title, presence: true, length: { maximum: 255 }
    validates :user_id, presence: true
    validates :status, presence: true

    default_scope { where(patron_id: Nimbos::Patron.current_id) }
    scope :latest, order("created_at desc")

    before_create :set_initials

    after_touch() { tire.update_index }
    index_name { "socialfreight-tickets" }#{Nimbos::Patron.current_id}
    mapping do
      indexes :id, type: :integer, index: :not_analyzed
      indexes :patron_id, type: :integer, index: :not_analyzed
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
      end
      indexes :close_date, type: 'date', index: :not_analyzed
      indexes :created_at, type: 'date', index: :not_analyzed
    end

    def to_indexed_json
      to_json(include: { user: { only: [:name, :surname] }, assigned: { only: [:name, :surname] } })
    end

    def self.search(query, page_no=1, per_page=10)
      tire.search(load: false, page: page_no, per_page: per_page) do
        query { string query } if query.present? #, default_operator: "AND"
        filter :term, patron_id: Nimbos::Patron.current_id
        sort  { by :created_at, "desc" } if query.blank?
        #filter :range, published_at: {lte: Time.zone.now}
      end
    end

    def self.paginate(options = {})
      page(options[:page]).per(options[:per_page])
    end

    def self.ticket_status
    	%w[open assigned closed]
    end

    def to_s
      reference
    end

    def to_param
      "#{id}-#{title.parameterize}"
    end

private
    def set_initials
      self.reference = Nimbos::Patron.generate_counter("Ticket", nil, nil)
    end
  end
end
