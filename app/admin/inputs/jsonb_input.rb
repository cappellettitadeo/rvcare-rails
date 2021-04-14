# frozen_string_literal: true

class JsonbInput < Formtastic::Inputs::TextInput
  def current_value
    (object.public_send(method) || {}).to_json
  end

  def input_html_options
    { value: current_value }.merge(super)
  end

  def to_html
    html = template.tag.div(class: 'js-jsoneditor') do
      builder.hidden_field(method, input_html_options)
    end

    input_wrapping do
      label_html << html
    end
  end
end
