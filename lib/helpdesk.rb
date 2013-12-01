require "helpdesk/engine"

module Helpdesk
	mattr_accessor :user_class
	mattr_accessor :branch_class
	mattr_accessor :company_class
	mattr_accessor :todolist_class
	mattr_accessor :document_class
	mattr_accessor :discussion_class
end
