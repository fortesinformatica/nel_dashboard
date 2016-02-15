# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '60s', :first_in => 5 do |job|

  response = JSON.parse(RestClient.get "http://atlas.grupofortes.com.br/dashboard/tramites/comparativo_da_semana.json")

  send_event 'atlas_week_change', {
    title: 'Tramites Semanais',
    current: response['current'],
    last: response['last']
  }
end
