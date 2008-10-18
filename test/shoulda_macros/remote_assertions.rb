class Test::Unit::TestCase

  def assert_remote_link_to(method, path)
    # assert_match %r{<a.*onclick="#{ajax_request_for(method, path)}"}, @response.body
    assert_match %r{<a.*onclick=".*#{ajax_request_for(method, path)}.*"}, @response.body
  end

  def ajax_request_for(method, path)
    /new Ajax\.Request\('#{Regexp.escape(path)}', *\{.*method:'#{method}'.*\}\)/
  end
end
