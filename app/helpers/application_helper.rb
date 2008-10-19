module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
  
  def number_to_formatted_currency(number)
    number_to_currency(number, :unit => "<span class='dollar-sign'>$</span>")
  end

  def user_name
    current_user.first_name
  end

  def li_for_stores
    if current_user.purchases.empty?
      ''
    else
      %{<li id="stores-index">#{link_to 'Stores', stores_path}</li>}
    end
  end
end
