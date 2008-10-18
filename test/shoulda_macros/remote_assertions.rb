class Test::Unit::TestCase

  def assert_remote_link_to(method, path, options = {})
    assert_match %r{<a.*onclick=".*#{ajax_request_for(method, path, options)}.*"}, @response.body
  end

  def ajax_request_for(method, path, options = {})
    expr = ""
    expr = "new Ajax\\."

    if options[:update]
      expr << 'Updater'
    else
      expr << 'Request'
    end

    expr << "\\("
    expr << "'#{Regexp.escape(options[:update])}', *" if options[:update]
    expr << "'#{Regexp.escape(path)}', *"
    expr << "\\{.*method:'#{method}'.*\\}\\)"

    Regexp.compile(expr)
  end
end
