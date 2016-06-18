class DatepickerInput < Formtastic::Inputs::StringInput

  def input_html_options
    format = Time::DATE_FORMATS[:american] || "%m/%d/%Y"
    super.merge(:"data-datepicker" => true, :value => object.send(method).try(:strftime, format))
  end

end