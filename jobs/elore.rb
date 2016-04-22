SCHEDULER.every '10s', :first_in => 0 do |job|

  url = ENV['ELORE_HOST'] || "http://localhost:3000/dashboard/users_counters.json"
  response = []

  begin 
    response = JSON.parse(RestClient.get(url))
  rescue Exception => e
    response << { label: "Erro", value: e.message }
  end
  
  send_event("elore_users_count", {
    title: 'Usuários do Elore',
    items: response
  })

end