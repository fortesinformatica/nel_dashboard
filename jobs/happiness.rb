require 'net/http'

SCHEDULER.every '5s' do
  # happiness_spreadsheet_points = get_happiness_spreadsheet_data
  # send_event('happiness', points: happiness_spreadsheet_points)
end

def get_happiness_spreadsheet_data
  uri = URI("https://spreadsheets.google.com/feeds/list/#{ENV["GOOGLE_SPREADSHEET_NOTA_SATISFACAO_KEY"]}/od6/private/full")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  headers = { "Authorization" => "GoogleLogin auth=#{ENV["GOOGLE_API_AUTH"]}" }
  response = http.request Net::HTTP::Get.new(uri.request_uri, headers)

  get_points_by response.body
end

def get_points_by body
  points = []
  doc = Nokogiri.XML(body, nil, 'EUC-JP')

  values = doc.css('entry').map{|r| r.children.last.children.text }
  last = values.shift
  values.push last
  values.count.times{|n| points << {x: n, y: values[n-1].gsub(",",".").to_f }}

  points
end