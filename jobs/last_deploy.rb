require 'httparty'
require 'rest-client'
require 'pry'

SCHEDULER.every '1h', :first_in => 0 do |job|
  send_event('atlas_last_deploy', last_deploy('Atlas', ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"]))
  send_event('leitor10_last_deploy', last_deploy('Leitor 10', ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"]))
end

def last_deploy project_name, access_token
  response = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/deploys/", params: { access_token: "#{access_token}", status: "active" })
  last_deploy = response['result']['deploys'].find { |deploy| deploy['environment'] == "production" }
  {
    title: project_name,
    user: last_deploy['local_username'],
    finish_time: last_deploy['finish_time'],
    time_ago: time_ago(last_deploy['finish_time']),
    environment: last_deploy['environment']
  }
end

def time_ago timestamp
  diff_seconds = Time.now.utc.to_i - timestamp
  case diff_seconds
    when 0..59
      "#{diff_seconds} seconds ago"
    when 60..(3600-1)
      "#{(diff_seconds/60.0).round} minutes ago"
    when 3600..(3600*24-1)
      "#{(diff_seconds/3600.0).round} hours ago"
    when (3600*24)..(3600*24*30)
      "#{(diff_seconds/(3600*24.0)).round} days ago"
    else
      Time.at(timestamp).strftime("%b %-d %Y, %l:%m %p")
  end
end