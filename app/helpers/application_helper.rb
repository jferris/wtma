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

  def autocomplete_field(obj, field)
    r = ''
    autocompleter = javascript_tag do
     %|var purchase_quantity_auto_completer = new Ajax.Autocompleter(
            'purchase_quantity',
            'purchase_quantity_autocomplete',
            '/purchases/autocomplete_purchase_quantity',
            {method: 'get'})|
    end
    if request.xhr?
      r << autocompleter
    else
      content_for :javascripts  do
        autocompleter
      end
    end
    r << %{<div class="auto_complete" id="#{obj}_#{field}_autocomplete"></div>}
    r
  end
end
