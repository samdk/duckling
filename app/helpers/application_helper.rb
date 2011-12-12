module ApplicationHelper
  # takes an array and makes some list items
  def array_to_li(items)
    items.collect {|i| "<li>#{h i}</li>"}.join("\n")
  end
  
  def link_to_attachment(upload)
    link_to "/attachment/#{upload.inspect}", upload.upload_file_name
  end
end
