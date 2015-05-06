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

# FIXME We should get these dates as parameters
start_date = DateTime.parse("2011-07-08")
end_date = DateTime.now

# Grab the data from stdin
# FIXME Use ARGV to read in parameters to filter first
# (ARGF will take contents of files pass in as arguments or, if no args, stdin
cal_data = ARGF.read

all_events = RiCal.parse_string(cal_data)

all_events.each do |cal|
  cal.events.each do |ev|
    if ev.recurs?
      # See if any occurrences are in our date range
      ev.occurrences(:starting => start_date, :before => end_date).each do |o|
        puts o.summary + " " + o.start_time.to_s
      end
    else
      # Just see if it's in our date range
      if (ev.start_time > start_date) && (ev.start_time < end_date)
        puts ev.summary + " " + ev.start_time.to_s
      end
    end
  end
end


