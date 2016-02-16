SCHEDULER.every '10s', :first_in => 0 do |job|

  width = ENV['MONITOR_WIDTH'].to_i
  margin = ENV['DASH_MARGIN'].to_i
  columns = ENV['DASH_COLUMNS'].to_i

  widget_width = (width/columns - 2 * margin) * 2
  widget_height = widget_width / 2

  url_atlas_cpu = "https://app.datadoghq.com/graph/embed?token=6b82a520cebd444288d826767e4b46dd0ab2aa2d68152162562c6c97dcdab955&height=#{widget_height}&width=#{widget_width}&legend=false"
  url_atlas_memory = "https://app.datadoghq.com/graph/embed?token=3960239b7b56a7019f537450fd8104ab5b1d226d898254e78ce254e641cd4122&height=#{widget_height}&width=#{widget_width}&legend=false"
  url_rds = "https://app.datadoghq.com/graph/embed?token=9baf2f9afb8d9396b719688ca5013badcf69e15a23f1b51cb01942867998ddb8&height=#{widget_height}&width=#{widget_width}&legend=false"

  send_event('datadog_atlas_cpu', url: url_atlas_cpu)
  send_event('datadog_rds', url: url_rds)
  send_event('datadog_atlas_memory', url: url_atlas_memory)
end
