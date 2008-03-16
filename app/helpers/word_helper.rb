module WordHelper
  def language_dropdown(instance_name, method)
    select(instance_name, method, {"en" => "en", "hu" => "hu"}, :include_blank => true)
  end
end
