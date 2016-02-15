SCHEDULER.every '10s', :first_in => 0 do |job|
    url_atlas_cpu = "https://app.datadoghq.com/graph/embed?token=6b82a520cebd444288d826767e4b46dd0ab2aa2d68152162562c6c97dcdab955&height=200&width=470&legend=false"
    url_atlas_memory = "https://app.datadoghq.com/graph/embed?token=3960239b7b56a7019f537450fd8104ab5b1d226d898254e78ce254e641cd4122&height=200&width=470&legend=false"
    url_rds = "https://app.datadoghq.com/graph/embed?token=9baf2f9afb8d9396b719688ca5013badcf69e15a23f1b51cb01942867998ddb8&height=200&width=470&legend=false"

    send_event('datadog_atlas_cpu', url: url_atlas_cpu)
    send_event('datadog_rds', url: url_rds)
    send_event('datadog_atlas_memory', url: url_atlas_memory)
end
