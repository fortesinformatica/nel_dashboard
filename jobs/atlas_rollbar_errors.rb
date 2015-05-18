require 'net/http'

SCHEDULER.every '5s' do  
  rollbar_errors = get_rollbar_errors
  
  errors = get_count_by(rollbar_errors, "error")
  info = get_count_by(rollbar_errors, "info")
  warning = get_count_by(rollbar_errors, "warning") 
  
  send_event('atlas_rollbar_errors', { value: [ errors, info, warning ] } )
end

def get_rollbar_errors
  uri = URI("https://api.rollbar.com/api/1/items/?access_token=#{ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"]}&?&status=active") 
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new(uri.request_uri))
  
  JSON.parse(response.body)["result"]["items"].map{|item| { label: item["level"], occurrences: item["unique_occurrences"] }}
end

def get_count_by rollbar_errors, type
  { label: type, value: rollbar_errors.select{|r| r[:label] == type}.map{|r| r[:occurrences]}.inject(:+) } 
end