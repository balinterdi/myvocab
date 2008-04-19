# Methods added to this helper will be available to all templates in the application.
# require 'nice_form_builder_helper'

module ApplicationHelper
  #FIXME: NiceFormBuilder should be included from the separate file,
  # but the nice_form_for is somehow then not fetchable from the views
  include ActionView::Helpers::TextHelper

  # include NiceFormBuilderMixin
  class NiceFormBuilder < ActionView::Helpers::FormBuilder
    (field_helpers - %w(check_box radio_button hidden_field)).each do |selector|
      src = <<-END_SRC
      def #{selector}(field, options = {})
        @template.content_tag("li",
                              @template.content_tag("label", field.to_s.humanize) +
                              super)

      end
      END_SRC
      class_eval src, __FILE__, __LINE__
      def wrap_in_fieldset(&proc)
        #content = capture(&proc)
        #concat(content_tag_string("fieldset", content), proc.binding)
      end
    end
  end

  def nice_form_for(name, object = nil, options = {}, &proc)
    options.reverse_merge! :title => "Form title comes here"
    options.reverse_merge! :submit_label => "submit"
#     concat("<fieldset>", proc.binding)
#     concat("<legend>#{options[:title]}</legend>", proc.binding)
#     concat("<ul>",  proc.binding)
    form_for(name,
             object,
             options, #.merge( :builder => NiceFormBuilder ),
             &proc)
#     concat(submit_tag(options[:submit_label].capitalize, :class => "submit_button"), proc.binding)
#     concat("</ul>",  proc.binding)
#     concat("</fieldset>", proc.binding)
  end

  def label_tag(name, object, method=false)
    if method
      id = "#{object}_#{method}"
    else
      id = object
    end
    "<label for=\"#{id}\">#{name}</label>"
  end

end
