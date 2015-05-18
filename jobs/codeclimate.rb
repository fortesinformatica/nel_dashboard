require 'net/http'

SCHEDULER.every '5s', :first_in => 0 do |job|  
  atlas_repo_id = ENV["CODE_CLIMATE_ATLAS_ID"] 
  leitor10_repo_id = ENV["CODE_CLIMATE_LEITOR10_ID"]
  
  atlas_stats = get_project_status atlas_repo_id
  leitor10_stats = get_project_status leitor10_repo_id
  
  send_event("atlas_codeclimate", {current: atlas_stats[:current_gpa], last: atlas_stats[:last_gpa]})
  send_event("leitor10_codeclimate", {current: leitor10_stats[:current_gpa], last: leitor10_stats[:last_gpa]})
end

def get_project_status repo_id
  uri = URI.parse("https://codeclimate.com/api/repos/#{repo_id}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  request.set_form_data({api_token: ENV["CODE_CLIMATE_API_TOKEN"]})
  response = http.request(request)
  
  stats = JSON.parse(response.body)
  { current_gpa: stats['last_snapshot']['gpa'].to_f, last_gpa: stats['previous_snapshot']['gpa'].to_f } 
end