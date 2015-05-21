require 'httparty'
 
SCHEDULER.every '5s', :first_in => 0 do |job|
  send_event('atlas_last_deploy', { title: "Atlas Last Deploy", current: get_project_last_deploy(ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"]) })
  send_event('leitor10_last_deploy', { title: "Leitor10 Last Deploy", current: get_project_last_deploy(ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"]) })
end
 
 def get_project_last_deploy project
  deploys = HTTParty.get("https://api.rollbar.com/api/1/deploys/?access_token=#{project}")['result']['deploys']
  last_deploy_time_unix = deploys.find { |deploy| deploy['environment'] == "production" }['finish_time']
  last_deploy_time = last_deploy_time_unix.nil? ? "Not available" : time_ago(last_deploy_time_unix)
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