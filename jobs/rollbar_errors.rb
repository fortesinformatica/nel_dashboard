require 'date'
require 'rest-client'
require 'pry'

SCHEDULER.every '5s' do
  atlas = rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"])
  leitor10 = rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"])
  send_event('atlas_rollbar_errors', atlas)
  send_event('leitor10_rollbar_errors', leitor10)
end

def rollbar_errors access_token

  today = Date.today
  data_init_current = '05-01-2015'
  data_final_current = '05-15-2015'

  data_init_last = '05-15-2015'
  data_final_last = '05-30-2015'

  response_critical_current = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_current, date_to: data_final_current, level: 'critical' })
  response_errors_current = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_current, date_to: data_final_current, level: 'error' })

  response_critical_last = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_last, date_to: data_final_last, level: 'critical' })
  response_errors_last = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_last, date_to: data_final_last, level: 'error' })

  items_response_critical_current = response_critical_current['result']['items'].map{|err| err['occurrences_count']}
  items_response_errors_current = response_errors_current['result']['items'].map{|err| err['occurrences_count']}
  items_response_critical_last = response_critical_last['result']['items'].map{|err| err['occurrences_count']}
  items_response_errors_last = response_errors_last['result']['items'].map{|err| err['occurrences_count']}

  {
    critical_current: items_response_critical_current.inject(:+),
    errors_current: items_response_errors_current.inject(:+),
    critical_last: items_response_critical_last.inject(:+),
    errors_last: items_response_errors_last.inject(:+)
  }
end