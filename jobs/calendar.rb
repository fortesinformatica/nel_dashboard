require 'google/api_client'
require 'digest/md5'
require 'active_support'
require 'active_support/all'

# Start the scheduler
SCHEDULER.every '5s', :first_in => 4 do |job|
#result.data
  send_event('calendar', { events: get_events })
end

def get_events
  uri = URI("https://www.googleapis.com/calendar/v3/calendars/#{ENV["GOOGLE_CALENDAR_ID"]}/events") 
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  headers = { "Authorization" => "Bearer #{ENV["GOOGLE_API_KEY"]}" }
  
  response = http.request(Net::HTTP::Get.new(uri.request_uri, headers))
  
  JSON.parse(response.body)["items"] #.map{|item| { label: item["level"], occurrences: item["unique_occurrences"] }}
end