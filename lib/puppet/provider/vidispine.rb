class Puppet::Provider::Vidispine < Puppet::Provider
  
  require 'net/http'
  require 'uri'
  require 'json'

  def rest_get (endpoint, options = {})
    return rest_action(endpoint, Net::HTTP::Get, nil, options)
  end

  def rest_post (endpoint, content, options = {})
    return rest_action(endpoint, Net::HTTP::Post, content, options)
  end
  
  def rest_put (endpoint, content, options = {})
    return rest_action(endpoint, Net::HTTP::Put, content, options)
  end

  def rest_delete (endpoint, options = {})
    return rest_action(endpoint, Net::HTTP::Delete, nil, options)
  end
  
  def rest_action (endpoint, method, content, options)
    uri  = URI("http://" + @resource[:vshostname] +":"+ @resource[:vsport] + endpoint)
    
    http    = Net::HTTP.new(uri.host, uri.port)
    request = method.new(uri.request_uri)

    request.basic_auth @resource[:vsuser], @resource[:vspass]

    if options[:accept] then
      request['Accept'] = options[:accept]
    end

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

    # It seems that whenever the providers are interested in parsing the response
    # they request JSON in the Accept header. For now I'm going to ignore the response
    # body if it's not JSON, instead of trying to parse XML.
    #
    if response['Content-Type'] == 'application/json' then
      if response.body == 'null' or response.body == '{}' then
        return {}
      else
        return JSON.parse(response.body)
      end
    end

    return true
  end
  
  private :rest_action

end

