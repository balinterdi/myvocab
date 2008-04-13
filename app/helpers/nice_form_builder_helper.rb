module NiceFormBuilderMixin

  class NiceFormBuilder < ActionView::Helpers::FormBuilder
    (field_helpers - %w(check_box radio_button hidden_field)).each do |selector|
      src = <<-END_SRC
      def #{selector}(field, options = {})
        @template.content_tag("li",
                              @template.content_tag("label", field.to_s.humanize + ":") +
                              super)
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end
  end

  def nice_form_for(name, object = nil, options = nil, &proc)
    concat("<fieldset>", proc.binding)
    concat("<legend> This is the legend </legend>", proc.binding)
    form_for(name,
             object,
             (options||{}).merge(:builder => NiceFormBuilder),
             &proc)
    concat(submit_tag("save".capitalize, :class => "submit_button"), proc.binding)
    concat("</fieldset>", proc.binding)
  end

end
