module ApplicationHelper
  # takes an array and makes some list items
  def array_to_li(items)
    items.collect {|i| "<li>#{h i}</li>"}.join("\n")
  end
  
  def link_to_attachment(upload)
    link_to "/attachment/#{upload.inspect}", upload.upload_file_name
  end
  
  def current_scope?(arg)
    if Hash === arg
      (!arg.key?(:controller) or arg[:controller] == controller_name) and (!arg.key?(:action) or arg[:action] == action_name)
    else
      current_page? arg
    end
  end
  
  def active?(arg)
    current_scope?(arg) ? 'active' : 'inactive'
  end
end
