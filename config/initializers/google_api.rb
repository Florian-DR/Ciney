require "json"
require "open-uri"
require 'googleauth'
require 'google/apis/calendar_v3'

calendar_scopes = ['https://www.googleapis.com/auth/calendar.readonly']

Google::Apis::RequestOptions.default.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: StringIO.new(ENV['ADDRESS_MAIL_JSON']),
  scope: calendar_scopes
)