module Vagrantboxes
  
  ENDPOINT = "http://api2.vagrantbox.es"

  module Client

    def self.search(term, api_url)
      base = api_url ? api_url : ENDPOINT
      url = "#{base}/boxes.json"
      if term
        url = "#{url}?q=#{term}"
      end
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body

      results = JSON.parse(data)
      results.sort! { |a,b| a['id'] <=> b['id'] }

      results.each { |result|
        puts "#{result['id'].to_s.ljust(4)} #{result['title'].ljust(25)} #{result['url']}"
      }
    end

    def self.url(id, api_url)
      base = api_url ? api_url : ENDPOINT
      if id =~ /^[-+]?[0-9]+$/
        url = "#{base}/boxes/#{id}.json"
        result = request(url)
        puts result['url']
      end
    end

    def self.show(id, api_url)
      base = api_url ? api_url : ENDPOINT
      if id =~ /^[-+]?[0-9]+$/
        url = "#{base}/boxes/#{id}.json"
        result = request(url)

        puts
        puts result['title']
        puts result['url']
        puts
        puts result['description']
      end
    end

    def request(url)
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body
      resp.code == "200" ? JSON.parse(data) : nil
    end

  end
end
