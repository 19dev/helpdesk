module Helpdesk
  module TicketsHelper

def tickets_list_table(tickets=@tickets, options={})
content = content_tag :div, class: "table-responsive", id: "tickets_list_div" do
table_for tickets, html: {class: "table table-striped table-bordered table-hover table-condensed", id: "tickets_list_table"} do
column title: t("simple_form.labels.ticket.reference"), html: { th: { class: "col-md-1" }  } do |ticket|
 	link_to ticket.reference, helpdesk.ticket_path(ticket)
 end
 column title: t("simple_form.labels.ticket.title"), html: { th: { class: "col-md-3" }  } do |ticket|
 	link_to ticket.title, helpdesk.ticket_path(ticket)
 end
 column title: t("simple_form.labels.ticket.user"), html: { th: { class: "col-md-2" } } do |ticket|
 	#image_tag user_mini_avatar(ticket.user), class: "img-circle", title: user_name(ticket.user) if ticket.user
 	user_name(ticket.user) if ticket.user
 end
 column title: t("simple_form.labels.ticket.created_at"), html: { th: { class: "col-md-2" } } do |ticket|
 	created_time(ticket.created_at.to_time)
 end
 column title: t("simple_form.labels.ticket.status"), html: { th: { class: "col-md-1" } } do |ticket|
 	t("tickets.status.#{ticket.status}")
 end
 column title: t("simple_form.labels.ticket.assigned"), html: { th: { class: "col-md-2" } } do |ticket|
 	#image_tag user_mini_avatar(ticket.assigned), class: "img-circle", title: user_name(ticket.assigned) if ticket.assigned
 	user_name(ticket.assigned) if ticket.assigned
 end
          column :close_date, title: t("simple_form.labels.ticket.close_date"), html: { th: { class: "col-md-2" } }
end
end

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
content = content_tag :div, class: "table-responsive", id: "tickets_list_div" do
table_for actions, html: {class: "table table-bordered table-condensed", id: "tickets_list_table"} do
 column title: t("simple_form.labels.ticket.action_user"), html: { th: { class: "col-md-1" } } do |action|
 	user_mini_avatar(action.user)
 end
 column title: t("simple_form.labels.ticket.action_desc"), html: { th: { class: "col-md-5" } } do |action|
 	"#{user_name(action.user)} #{ticket_action_desc(action)}"
 end
 column title: t("simple_form.labels.ticket.action_date"), html: { th: { class: "col-md-2" } } do |action|
 	created_time(action.created_at.to_time)
 end
end
end
content.html_safe
end
  end
end