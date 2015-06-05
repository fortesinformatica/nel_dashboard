require 'rest-client'
require 'pry'

SCHEDULER.every '5s', :first_in => 0 do |job|
  atlas_stats = project_status ENV["CODE_CLIMATE_ATLAS_ID"]
  leitor10_stats = project_status ENV["CODE_CLIMATE_LEITOR10_ID"]
  send_event("atlas_codeclimate", atlas_stats)
  send_event("atlas_coverage", atlas_stats)

  send_event("leitor10_codeclimate", leitor10_stats)
  send_event("leitor10_coverage", leitor10_stats)
end

def project_status repo_id
  response = JSON.parse(RestClient.get "https://codeclimate.com/api/repos/#{repo_id}", params: { api_token: ENV["CODE_CLIMATE_API_TOKEN"] })

  {
    name: response['name'],
    current: response['last_snapshot']['gpa'],
    last: response['previous_snapshot']['gpa'],
    current_coverage: response['last_snapshot']['covered_percent'],
    last_coverage: response['previous_snapshot']['covered_percent']
  }
end
