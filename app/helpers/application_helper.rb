module ApplicationHelper
  # takes an array and makes some list items
  def array_to_li(items)
    items.collect {|i| "<li>#{h i}</li>"}.join("\n")
  end
end

