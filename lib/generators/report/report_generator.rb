# frozen_string_literal: true

class ReportGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :parameters, type: :array, default: [], banner: 'parameter parameter'

  def create_report_file
    template 'report.rb.erb', File.join('app/models', "#{file_name}_report.rb")
    template 'report_spec.rb.erb', File.join('spec/models', "#{file_name}_report_spec.rb")
    template 'report_parameters.json_schema.erb', File.join('config/schemas', "#{file_name}_parameters.json_schema")
  end

  private

  def parameter_name(parameter)
    parameter.split(':').first
  end

  def parameter_type(parameter)
    parameter.split(':').second
  end
end
