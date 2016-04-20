SCHEDULER.every '10s', :first_in => 0 do |job|

  width = ENV['MONITOR_WIDTH'].to_i
  margin = ENV['DASH_MARGIN'].to_i
  columns = ENV['DASH_COLUMNS'].to_i

  widget_width = (width/columns - 2 * margin) * 2
  widget_height = widget_width / 2

  CHAPELETA = "https://app.datadoghq.com/graph/embed?token="
  RABETA = "&height=#{widget_height}&width=#{widget_width}&legend=false"

  atlas_cpu = "21f775e1301d73ccc877866d5bb6c4ba640cd19fe28b1d25bf68593e97f06a59"
  atlas_memory = "eb18c75089ebcdefc16b91e04c765d93108c34a6a295297c2667c06964271637"
  url_rds = "https://app.datadoghq.com/graph/embed?token=9baf2f9afb8d9396b719688ca5013badcf69e15a23f1b51cb01942867998ddb8&height=#{widget_height}&width=#{widget_width}&legend=false"

  send_event('datadog_atlas_cpu', url: url(atlas_cpu))
  send_event('datadog_atlas_memory', url: url(atlas_memory))
  send_event('datadog_rds', url: url_rds)

  def url(toco)
    "#{CHAPELETA}#{toco}#{RABETA}"
  end

end
