require './lib/dashing_ec2'

SCHEDULER.every '5m', :first_in => 0 do |job|
  dashing_ec2 = DashingEC2.new({
      :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :secret_access_key => ENV["AWS_ACCESS_KEY_SECRET"]
  })

  instance = {name: 'bookmaker-production-nova', instance_id: "i-2ad391d0", region: 'us-east-1'}

  send_event "leitor10_cpu", { points: get_cpu_series(dashing_ec2, instance) }
end

def get_cpu_series dashing_ec2, instance
  dashing_ec2.getInstanceStats(instance[:instance_id], instance[:region], "CPUUtilization", :average)[:data]
end