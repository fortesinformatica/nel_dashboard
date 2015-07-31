# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

  response = JSON.parse(RestClient.get "http://atlas.grupofortes.com.br/dashboard/tramites/por_empresa.json", params: { de: (Date.today - 7.days), ate: Date.today })

  data = []

  response.each do | empresa |
    data << { label: empresa["descricao"].split(" ")[0..1].join(" "), value: empresa["quantidade"] }
  end

  send_event 'atlas-tramites-por-empresa', { value: data }
end