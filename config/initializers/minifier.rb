Rails.application.configure do
  config.assets.compile = true
  config.assets.debug = false

  uglifier = Uglifier.new(harmony: true)

  config.assets.js_compressor  = uglifier
  config.assets.css_compressor = :yui

  config.middleware.use Rack::Deflater
  config.middleware.insert_before ActionDispatch::Static, Rack::Deflater

  config.middleware.use HtmlCompressor::Rack,
    compress_css: false,
    compress_javascript: true,
    css_compressor: :yui,
    enabled: true,
    javascript_compressor: uglifier,
    preserve_line_breaks: false,
    remove_comments: true,
    remove_form_attributes: false,
    remove_http_protocol: false,
    remove_https_protocol: false,
    remove_input_attributes: true,
    remove_intertag_spaces: false,
    remove_javascript_protocol: true,
    remove_link_attributes: true,
    remove_multi_spaces: true,
    remove_quotes: true,
    remove_script_attributes: true,
    remove_style_attributes: true,
    simple_boolean_attributes: true,
    simple_doctype: false
end
