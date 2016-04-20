
SCHEDULER.every '10s', :first_in => 0 do |job|

  width = ENV['MONITOR_WIDTH'].to_i
  margin = ENV['DASH_MARGIN'].to_i
  columns = ENV['DASH_COLUMNS'].to_i

  widget_width = (width/columns - 2 * margin) * 2
  widget_height = widget_width / 2

  chapeleta = "https://app.datadoghq.com/graph/embed?token="
  rabeta = "&height=#{widget_height}&width=#{widget_width}&legend=false"
  

  atlas_cpu = "5268946ac059b467b24dd429b286f0134aab4dbdfc4a4539d70a76f27fa4d38d"
  atlas_memory = "eb18c75089ebcdefc16b91e04c765d93108c34a6a295297c2667c06964271637"
  url_rds = "https://app.datadoghq.com/graph/embed?token=9baf2f9afb8d9396b719688ca5013badcf69e15a23f1b51cb01942867998ddb8&height=#{widget_height}&width=#{widget_width}&legend=false"

  send_event('datadog_atlas_cpu', url: "#{chapeleta}#{atlas_cpu}#{rabeta}")
  send_event('datadog_atlas_memory', url: "#{chapeleta}#{atlas_memory}#{rabeta}")
  send_event('datadog_rds', url: url_rds)

end

