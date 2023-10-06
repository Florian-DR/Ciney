require "json"
require "open-uri"
require 'googleauth'
require 'google/apis/calendar_v3'

calendar_scopes = ['https://www.googleapis.com/auth/calendar.readonly']
client_id = ENV['GOOGLE_CLIENT_ID']
client_secret = ENV['GOOGLE_CLIENT_SECRET']


Google::Apis::RequestOptions.default.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open('/Users/florianderadigues/code/Florian-DR/Ciney/config/ciney-gites-site-3beb58560630.json'),
  scope: calendar_scopes
)