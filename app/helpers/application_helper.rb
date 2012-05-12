module ApplicationHelper
  # takes an array and makes some list items
  def array_to_li(items)
    items.collect {|i| "<li>#{h i}</li>"}.join("\n")
  end
  
  def current_scope?(*args)
    args.any? do |arg|
      if Hash === arg
        (!arg.key?(:controller) or arg[:controller] == controller_name) and (!arg.key?(:action) or arg[:action] == action_name)
      else
        current_page? arg
      end
    end
  end
  
  def active(arg)
    arg = current_scope?(arg) unless true === arg || false === arg
    arg ? 'active' : 'inactive'
  end

  def errors_for(obj)
    if obj.errors.any?
      haml_tag :div, :class => 'errors' do
        haml_tag :h2, "#{pluralize(@organization.errors.count, 'error')} prevented this organization from being saved:"

        haml_tag :ul do
          obj.errors.full_messages.collect do |msg|
            haml_tag :li, msg
          end
        end
      end
    end
  end
  
end
