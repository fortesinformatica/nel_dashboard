require 'net/http'

SCHEDULER.every '60s' do
  rollbar_errors_atlas = get_rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"])
  rollbar_errors_leitor10 = get_rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"])   
  
  send_event('atlas_rollbar_errors', { value: [ rollbar_errors_atlas[:error], 
                                                rollbar_errors_atlas[:info], 
                                                rollbar_errors_atlas[:warning] ] } )
  
  send_event('leitor10_rollbar_errors', { value: [ rollbar_errors_leitor10[:error], 
                                                rollbar_errors_leitor10[:info], 
                                                rollbar_errors_leitor10[:warning] ] } )                                              
end

def get_rollbar_errors project
  uri = URI("https://api.rollbar.com/api/1/items/?access_token=#{project}&?&status=active") 
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new(uri.request_uri))
  
  items = JSON.parse(response.body)["result"]["items"].map{|item| { label: item["level"], occurrences: item["unique_occurrences"] }}
  
  { 
    error: get_count_by(items, "error"),
    warning: get_count_by(items, "warning"),
    info: get_count_by(items, "info"),
  }
  
end

def get_count_by rollbar_errors, type
  { label: type, value: rollbar_errors.select{|r| r[:label] == type && r[:occurrences].present?}.map{|r| r[:occurrences]}.inject(:+) } 
end