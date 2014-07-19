module Helpdesk
  class Team < ActiveRecord::Base

  	has_many :tickets
  	
  	validates :title, presence: true, length: { maximum: 100 }
  	validates :email, presence: true, length: { maximum: 30 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  	default_scope { where(patron_id: Nimbos::Patron.current_id) }

  end
end
