module NiceFormBuilder

  class NiceFormBuilder < ActionView::Helpers::FormBuilder
    (field_helpers - %w(check_box radio_button hidden_field)).each do |selector|
      src = <<-END_SRC
      def #{selector}(field, options = {})
        @template.content_tag("tr",
                              @template.content_tag("td", field.to_s.humanize + ":") +
                              @template.content_tag("td", super))
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end
  end

  def tabular_form_for(name, object = nil, options = nil, &proc)
    concat("<table>", proc.binding)
    form_for(name,
             object,
             (options||{}).merge(:builder => NiceFormBuilder),
             &proc)
    concat("</table>", proc.binding)
  end

end
