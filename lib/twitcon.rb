class Twitcon
  
   @@USER_URIS = {   
  	:friends => '/statuses/friends/LarryKooper.json',
  	:followers => '/statuses/followers/LarryKooper.json'
  }  
   
  API_ROOT_URL = 'twitter.com'
  
  def self.create_http_get_request(uri, params={})
    path = (params.size > 0) ? "#{uri}?#{params.to_http_str}" : uri 
    $stderr.puts "pineapple"
    $stderr.puts path
    response = Net::HTTP.get API_ROOT_URL, path     
  end 
  
  def self.my(action, options = {})
    params = options 
    response = self.create_http_get_request(@@USER_URIS[action], params)     
    #$stderr.puts response
    retval = unmarshal(response)
  end 
  
  def self.unmarshal(data)
    result = JSON.parse(data)    
  end 

end

class Hash
  # Returns string formatted for HTTP URL encoded name-value pairs.
  # For example,
  #  {:id => 'thomas_hardy'}.to_http_str 
  #  # => "id=thomas_hardy"
  #  {:id => 23423, :since => Time.now}.to_http_str
  #  # => "since=Thu,%2021%20Jun%202007%2012:10:05%20-0500&id=23423"
  def to_http_str
    result = ''
    return result if self.empty?
    self.each do |key, val|
      result << "#{key}=#{CGI.escape(val.to_s)}&"
    end
    result.chop # remove the last '&' character, since it can be discarded
  end
end