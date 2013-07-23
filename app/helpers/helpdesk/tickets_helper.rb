module Helpdesk
  module TicketsHelper

		def tickets_list_table(tickets=@tickets, options={})
			content = content_tag :div, class: "row-fluid", id: "tickets_list_div" do
				table_for tickets, html: {class: "table table-bordered table-condensed", id: "tickets_list_table"} do
				  column title: t("tickets.label.title"), html: { th: { class: "span4" }  } do |ticket|
				  	link_to ticket.title, helpdesk.ticket_path(ticket)
				  end
				  column title: t("tickets.label.user"), html: { th: { class: "span1" } } do |ticket|
				  	#image_tag user_mini_avatar(ticket.user), class: "img-circle", title: user_name(ticket.user) if ticket.user
				  	user_mini_avatar(ticket.user) if ticket.user
				  end
				  column title: t("tickets.label.created_at"), html: { th: { class: "span2" } } do |ticket|
				  	created_time(ticket.created_at.to_time)
				  end
				  column title: t("tickets.label.status"), html: { th: { class: "span2" } } do |ticket|
				  	t("tickets.status.#{ticket.status}")
				  end
				  column title: t("tickets.label.assigned"), html: { th: { class: "span1" } } do |ticket|
				  	#image_tag user_mini_avatar(ticket.assigned), class: "img-circle", title: user_name(ticket.assigned) if ticket.assigned
				  	user_mini_avatar(ticket.assigned) if ticket.assigned
				  end
          		  column :close_date, title: t("tickets.label.close_date"), html: { th: { class: "span1" } }
				  column title: "", html: { th: { class: "span1" } } do |ticket|
				  	#render partial: "helpdesk/tickets/actions", locals: { ticket: ticket }
				  	#link_to t("defaults.link.edit"), helpdesk.edit_ticket_path(ticket) unless options[:hide_edit_link]
				  end
				end
			end

			content <<	(content_tag :div, class: "pagination" do
				paginate tickets
			end if options[:show_pagination])

			content.html_safe
		end

		def ticket_action_desc(action)
			if action.action_code == "assigned"
			  t("tickets.action_codes.#{action.action_code}", user: action.assigned)
			else
        t("tickets.action_codes.#{action.action_code}")
			end
		end

		def ticket_actions_list_table(actions=@actions, options={})
			content = content_tag :div, class: "row-fluid", id: "tickets_list_div" do
				table_for actions, html: {class: "table table-bordered table-condensed", id: "tickets_list_table"} do
				  column title: t("actions.label.user"), html: { th: { class: "span1" } } do |action|
				  	user_mini_avatar(action.user)
				  end
				  column title: t("actions.label.status"), html: { th: { class: "span5" } } do |action|
				  	"#{user_name(action.user)} #{ticket_action_desc(action)}"
				  end
				  column title: t("actions.label.created_at"), html: { th: { class: "span2" } } do |action|
				  	created_time(action.created_at.to_time)
				  end
				end
			end
			content.html_safe
		end
  end
end
