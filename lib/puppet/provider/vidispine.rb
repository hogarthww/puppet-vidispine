class Puppet::Provider::Vidispine < Puppet::Provider
  
  require 'net/http'
  require 'uri'
  require 'json'

  def rest_get (endpoint)
    return rest_action(endpoint, Net::HTTP::Get)
  end

  def rest_post (endpoint, content)
    return rest_action(endpoint, Net::HTTP::Post, content)
  end
  
  def rest_put (endpoint, content)
    return rest_action(endpoint, Net::HTTP::Put, content)
  end

  def rest_delete (endpoint)
    return rest_action(endpoint, Net::HTTP::Delete)
  end
  
  def rest_action (endpoint, method, content=nil)
    uri  = URI("http://" + @resource[:vshostname] +":"+ @resource[:vsport] + endpoint)
    
    http    = Net::HTTP.new(uri.host, uri.port)
    request = method.new(uri.request_uri)

    request.basic_auth @resource[:vsuser], @resource[:vspass]
    request['Accept'] = 'application/json'

    if not content.nil? then
      request.body = content

      if content =~ /^\s*</ then
        request['Content-Type'] = 'application/xml'
      elsif content =~ /^\s*\{/ then
        request['Content-Type'] = 'application/json'
      end
    end

    response = http.request(request)

    if not response.is_a?(Net::HTTPSuccess) then
      raise Puppet::Error, "Vidispine responded with HTTP #{response.code}: \"#{response.body}\""
    end

    if response.body == 'null' or response.body == '{}' then
      return {}
    else
      return JSON.parse(response.body)
    end

  end
  
  private :rest_action

end

