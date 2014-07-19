module Helpdesk
  class Ticket < ActiveRecord::Base

    # include Tire::Model::Search
    # include Tire::Model::Callbacks

    belongs_to :user, class_name: Helpdesk.user_class
    belongs_to :assigned, class_name: Helpdesk.user_class
    belongs_to :team

    has_many   :ticket_actions, dependent: :destroy
    has_many   :discussions, class_name: Helpdesk.discussion_class, as: :target, dependent: :destroy

    validates :title, presence: true, length: { maximum: 255 }
    validates :user_id, presence: true
    validates :status, presence: true
    validates :desc, presence: true, length: { maximum: 500 }
    validates :status, inclusion: { in: %w(active closed cancelled) }
    validates :reference, presence: true
    validates_associated :team
    validates_associated :assigned

    default_scope { where(patron_id: Nimbos::Patron.current_id) }
    scope :latest, order("created_at desc")

    before_create :set_initials

    def self.search(search_id)
      search = Roster::Search.find(search_id)
      tickets = Helpdesk::Ticket.order(created_at: :desc)
      tickets = tickets.where("reference like ?", "%#{search.filter["reference"]}%") if search.filter["reference"].present?
      tickets = tickets.where("title like ?", "%#{search.filter["title"]}%") if search.filter["title"].present?
      tickets = tickets.where(user_id: search.filter["user_id"]) if search.filter["user_id"].present?
      tickets = tickets.where(assigned_id: search.filter["assigned_id"]) if search.filter["assigned_id"].present?
      tickets = tickets.where(status: search.filter["status"]) if search.filter["status"].present?
      tickets = tickets.where(create_date: search.filter["create_date1"]..search.filter["create_date2"]) if (search.filter["create_date1"].present? && self.filter["create_date2"].present?)
      tickets
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


    # after_touch() { tire.update_index }
    # index_name { "socialfreight-tickets" }#{Nimbos::Patron.current_id}
    # mapping do
    #   indexes :id, type: :integer, index: :not_analyzed
    #   indexes :patron_id, type: :integer, index: :not_analyzed
    #   indexes :title, analyzer: 'snowball', boost: 100
    #   indexes :desc, analyzer: 'snowball'
    #   indexes :status, index: :not_analyzed
    #   indexes :user do
    #     indexes :name, analyzer: 'snowball'
    #     indexes :avatar, index: :not_analyzed
    #   end
    #   indexes :assigned do
    #     indexes :name, analyzer: 'snowball'
    #   end
    #   indexes :close_date, type: 'date', index: :not_analyzed
    #   indexes :created_at, type: 'date', index: :not_analyzed
    # end

    # def to_indexed_json
    #   to_json(include: { user: { only: [:name] }, assigned: { only: [:name] } })
    # end

    # def self.search(query, page_no=1, per_page=10)
    #   tire.search(load: false, page: page_no, per_page: per_page) do
    #     query { string query } if query.present? #, default_operator: "AND"
    #     filter :term, patron_id: Nimbos::Patron.current_id
    #     sort  { by :created_at, "desc" } if query.blank?
    #     #filter :range, published_at: {lte: Time.zone.now}
    #   end
    # end

    # def self.paginate(options = {})
    #   page(options[:page]).per(options[:per_page])
    # end
