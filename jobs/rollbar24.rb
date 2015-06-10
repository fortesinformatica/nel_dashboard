require 'date'
require 'rest-client'
require 'pry'

SCHEDULER.every '600s' do
  atlas = rollbar24_errors(ENV["ROLLBAR_ACCESS_TOKEN_ATLAS"])
  leitor10 = rollbar24_errors(ENV["ROLLBAR_ACCESS_TOKEN_LEITOR10"])
  send_event('atlas_rollbar', atlas)
  send_event('leitor10_rollbar', leitor10)
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

  total = critical_occurrences_count + errors_occurrences_count

  {
    faults_sum: total > 0 ? total : "Sem erros",
    errors: errors,
    criticals: criticals
  }
end