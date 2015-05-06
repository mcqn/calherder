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

# Grab the data from stdin
# FIXME Use ARGV to read in parameters to filter first
# (ARGF will take contents of files pass in as arguments or, if no args, stdin
cal_data = ARGF.read

all_events = RiCal.parse_string(cal_data)

# Find any relevant events
all_events.each do |cal|
  cal.events.delete_if do |ev|
    #(!ev.summary.downcase.include?("maker night") && !ev.summary.downcase.include?("maker day"))
    (ev.summary.downcase.include?("cancel"))
  end
end

puts all_events

