require 'date'
require 'rest-client'

SCHEDULER.every '20s', :first_in => 0 do
  atlas = rollbar24_errors(ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"])
  leitor10 = rollbar24_errors(ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"])
  eva = rollbar_errors(ENV["ROLLBAR_ACCESS_TOKEN_EVA"])

  send_event('atlas_rollbar', atlas)
  send_event('leitor10_rollbar', leitor10)
  send_event('eva_rollbar', eva)
end

def rollbar24_errors access_token
  today = Date.today
  data_init_current = (today - 1).strftime('%m-%d-%Y')
  data_final_current = (today).strftime('%m-%d-%Y')

  response_critical = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_current, date_to: data_final_current, level: 'critical' })
  response_errors = JSON.parse(RestClient.get "https://api.rollbar.com/api/1/items/", params: { access_token: "#{access_token}", environment: 'production', date_from: data_init_current, date_to: data_final_current, level: 'error' })


  critical_occurrences_count = response_critical['result']['items'].map{|err| err['occurrences_count']}.inject(:+)
  errors_occurrences_count = response_errors['result']['items'].map{|err| err['occurrences_count']}.inject(:+)

  errors = response_errors['result']['items']
  criticals = response_critical['result']['items']

  total = critical_occurrences_count.to_i + errors_occurrences_count.to_i

  {
    faults_sum: total,
    errors: errors,
    criticals: criticals
  }
end
