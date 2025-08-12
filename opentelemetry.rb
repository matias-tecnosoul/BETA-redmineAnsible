# OpenTelemetry with MANUAL TRACING for debug
begin
  require 'opentelemetry/sdk'
  require 'opentelemetry/instrumentation/all'
  
  OpenTelemetry::SDK.configure do |c|
    c.service_name = 'redmine'
    c.use_all() 
    
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
        OpenTelemetry::Exporter::OTLP::Exporter.new(
          endpoint: 'http://localhost:4318/v1/traces'
        )
      )
    )
  end
  
  Rails.logger.info "🎯 OpenTelemetry configured"
  
  # MANUAL SPAN TEST
  tracer = OpenTelemetry.tracer_provider.tracer('redmine-test')
  tracer.in_span('redmine-startup') do |span|
    span.set_attribute('service.name', 'redmine')
    span.set_attribute('test', 'manual_span')
    Rails.logger.info "📡 Manual span created for testing"
  end
  
rescue => e
  Rails.logger.error "❌ OpenTelemetry error: #{e.message}"
end
