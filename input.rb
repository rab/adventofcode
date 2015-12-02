require 'uri'
require 'net/http'

module Input
  extend self
  def for_day(day)
    uri = URI('http://adventofcode.com/day/%s/input'%[day.to_s])
    req = Net::HTTP::Get.new(uri)
    req['Cookie'] = File.read('./.session') if File.exist?('./.session')
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    res.body
  end
end
