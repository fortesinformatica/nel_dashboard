require 'aws-sdk'
require 'time'

SCHEDULER.every '60s', :first_in => 0 do |job|
  Aws.config.update({ region: 'us-east-1', credentials: Aws::Credentials.new(ENV['AWS_ID'], ENV['AWS_KEY']) })

  production_count = host_count :production
  staging_count = host_count :staging
  rds = rds_connections ['atlas-production', 'atlasbi', 'bookmaker-production']

  send_event("leitor10_host_count", {
    title: 'Leitor10 ELB',
    items: [
      { label: 'Production', value: production_count },
      { label: 'Staging', value: staging_count }
    ]
  })
  send_event("leitor10_rds_connections", {
    title: 'RDS Connections',
    items: [
      { label: 'Atlas', value: rds[0] },
      { label: 'Atlas BI', value: rds[1] },
      { label: 'Bookmaker', value: rds[2] }
    ]
  })
end

def host_count(env)

  environments = {
    production: 'awseb-e-w-AWSEBLoa-1NBFHYUJLIDIK',
    staging: 'awseb-e-2-AWSEBLoa-1WUSAAMLI6AVO'
  }

  cloudwatch = Aws::CloudWatch::Client.new(region: 'us-east-1')
  response = cloudwatch.get_metric_statistics({
    namespace: 'AWS/ELB',
    metric_name: 'HealthyHostCount',
    statistics: ['Average'],
    dimensions: [{ name: 'LoadBalancerName', value: environments[env]}],
    start_time: (Time.now - 60).iso8601,
    end_time: Time.now.iso8601,
    period: 300
  })

  response.datapoints.last.average
end

def rds_connections(identifiers = [])
  cloudwatch = Aws::CloudWatch::Client.new(region: 'us-east-1')
  identifiers.map do |id|
    response = cloudwatch.get_metric_statistics({
      namespace: 'AWS/RDS',
      metric_name: 'DatabaseConnections',
      statistics: ['Average'],
      dimensions: [{ name: 'DBInstanceIdentifier', value: id}],
      start_time: (Time.now - 60).iso8601,
      end_time: Time.now.iso8601,
      period: 300
    })

    response.datapoints.last.average
  end
end
