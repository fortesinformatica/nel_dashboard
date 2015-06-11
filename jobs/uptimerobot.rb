require 'uptimerobot'

SCHEDULER.every '1m', :first_in => 0 do |job|
  client = UptimeRobot::Client.new(apiKey: ENV['UPTIMEROBOT_APIKEY'])

  raw_monitors = client.getMonitors['monitors']['monitor']
  monitors = raw_monitors.map { |monitor|
    {
      friendlyname: monitor['friendlyname'],
      status: monitor['status'],
      status_class: 'led-' << monitor['status']
    }
  }

  send_event('uptimerobot', { monitors: monitors } )
end