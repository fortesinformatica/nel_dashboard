require 'date'
require 'rest-client'
require 'pry'

SCHEDULER.every '5m', :first_in => 0 do
  atlas = rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"])
  leitor10 = rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"])
  send_event('atlas_rollbar_errors', atlas)
  send_event('leitor10_rollbar_errors', leitor10)
end

def rollbar_errors access_token

  today = Date.today
  data_init_current = (today - 7).strftime('%m-%d-%Y')
  data_final_current = (today).strftime('%m-%d-%Y')

  data_init_last = (today - 15).strftime('%m-%d-%Y')
  data_final_last = (today - 8).strftime('%m-%d-%Y')

  response_critical_current = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_current, date_to: data_final_current, level: 'critical' })
  response_errors_current = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_current, date_to: data_final_current, level: 'error' })

  response_critical_last = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_last, date_to: data_final_last, level: 'critical' })
  response_errors_last = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_last, date_to: data_final_last, level: 'error' })

  items_response_critical_current = response_critical_current['result']['items'].map{|err| err['occurrences_count']}
  items_response_errors_current = response_errors_current['result']['items'].map{|err| err['occurrences_count']}
  items_response_critical_last = response_critical_last['result']['items'].map{|err| err['occurrences_count']}
  items_response_errors_last = response_errors_last['result']['items'].map{|err| err['occurrences_count']}

  critical_current = items_response_critical_current.inject(:+)
  errors_current = items_response_errors_current.inject(:+)
  critical_last = items_response_critical_last.inject(:+)
  errors_last = items_response_errors_last.inject(:+)

  critical_distinct_current = response_critical_current['result']['items'].length
  errors_distinct_current = response_errors_current['result']['items'].length
  critical_distinct_last = response_critical_last['result']['items'].length
  errors_distinct_last = response_errors_last['result']['items'].length

  {
    errors_current: critical_current.to_i + errors_current.to_i,
    errors_last: critical_last.to_i + errors_last.to_i,
    errors_distinct_current: critical_distinct_current.to_i + errors_distinct_current.to_i,
    errors_distinct_last: critical_distinct_last.to_i + errors_distinct_last.to_i
  }
end