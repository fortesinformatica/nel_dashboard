# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '3600s', :first_in => 5 do |job|

  response = JSON.parse(RestClient.get "http://atlas.grupofortes.com.br/dashboard/tramites/comparativo_da_semana.json")
  
  last = []
  current = []

  response.each do |k, v|
    last << { x: k , y: v["last_week"] }
    current << { x: k, y: v["current_week"] }
  end

  send_event 'atlas-tramites-semanais', { points: last, points2: current, displayedValue: current.last[:y] }
end