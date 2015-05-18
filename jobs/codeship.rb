require 'codeship'

SCHEDULER.every '5s', :first_in => 0 do |job|
  project_status_atlas = Codeship::Status.new(ENV["CODESHIP_ATLAS"], branch: "master")
  send_event("atlas_codeship", {current: project_status_atlas.status})
  
  project_status_leitor10 = Codeship::Status.new(ENV["CODESHIP_LEITOR10"], branch: "master")
  send_event("leitor10_codeship", {current: project_status_leitor10.status})
end