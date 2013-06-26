#!/usr/bin/ruby
# cal_filter
# Script to filter iCal entries, generating a new iCal feed with only the
# matching items

require 'rubygems'
require 'time'
require 'net/http'
require 'net/https'
require 'ri_cal'
#require 'time_start_and_end_extensions'
require 'local_config'

# Download and parse the calendar
if (CAL_URL_IS_HTTPS)
  cal_uri = URI.parse(CAL_URL)
  cal_http = Net::HTTP.new(cal_uri.host, 443)
  cal_http.use_ssl = true
  cal_req = Net::HTTP::Get.new(cal_uri.request_uri)
  cal_data = cal_http.request(cal_req)
else
  cal_data = Net::HTTP.get_response(URI.parse(CAL_URL))
end

all_events = RiCal.parse_string(cal_data.body)

# Find any relevant events
all_events.each do |cal|
  cal.events.delete_if do |ev|
    (!ev.summary.downcase.include?("maker night") && !ev.summary.downcase.include?("maker day"))
  end
end

puts all_events

