# Methods added to this helper will be available to all templates in the application.
require 'nice_form_builder_helper'

module ApplicationHelper

  include NiceFormBuilder

  def label_tag(name, object, method=false)
    if method
      id = "#{object}_#{method}"
    else
      id = object
    end
    "<label for=\"#{id}\">#{name}</label>"
  end

  def list_tag(ordered, options = {})
    if ordered
      content_tag_string(:ol, nil, options)
    else
      content_tag_string(:ul, nil, options)
    end
  end

  def end_list_tag(ordered)
    if ordered
      "</ol>"
    else
      "</ul>"
    end
  end

end
