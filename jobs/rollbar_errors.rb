require 'rest-client'
require 'pry'

SCHEDULER.every '60s' do
  atlas = rollbar_errors ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"]
  # leitor10 = rollbar_errors ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"]

  send_event('atlas_rollbar_errors', { value: atlas } )
  # send_event('leitor10_rollbar_errors', { value: leitor10 } )
end

def rollbar_errors access_token
  response = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", status: "active" })
  items = response['result']['items'].map { |item| { label: item["level"], occurrences: item["unique_occurrences"] } }
  [
    get_count_by(items, 'error'),
    get_count_by(items, 'warning'),
    get_count_by(items, 'info')
  ]
end

def get_count_by rollbar_errors, type
  { label: type, value: rollbar_errors.select{|r| r[:label] == type && r[:occurrences].present?}.map{|r| r[:occurrences]}.inject(:+) }
end