require 'google/api_client'
require 'google_drive'
require 'pry'

SCHEDULER.every '5h', :first_in => 0 do
  session = create_session
  worksheets = worksheets_by_title session, ENV['SPREADSHEET_TITLE']
  points = make_graph_points worksheets
  send_event('happiness', points: points)
end

def create_session
  session = GoogleDrive.login_with_oauth(ENV['GOOGLE_ACCESS_TOKEN'])
end

def worksheets_by_title session, title
  spreadsheet = session.spreadsheet_by_title(title)
  worksheets = spreadsheet.worksheets[0] unless spreadsheet.nil?
end

def make_graph_points worksheets
  points = []
  values = worksheets.cells.values
  (0..values.length - 1).step(2) do |n|
    points << { x: Date.parse(values[n]).to_time.to_i, y: values[n + 1].to_f }
  end
  points
end