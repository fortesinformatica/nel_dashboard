require "google/api_client"
require "google_drive"

begin
  client = Google::APIClient.new
  auth = client.authorization
  auth.client_id = "506776271030-8q82kbcekak2p72sbbm0h22d5ost0t69.apps.googleusercontent.com"
  auth.client_secret = "GaU4bWzQasQdgOR2HGwri30x"
  auth.scope = [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/"
  ]
  auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
  print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
  print("2. Enter the authorization code shown in the page: ")
  auth.code = $stdin.gets.chomp
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  auth.fetch_access_token!
  access_token = auth.access_token
rescue Exception => e
  puts e.message
end