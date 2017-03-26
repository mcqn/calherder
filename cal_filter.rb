#!/usr/bin/ruby
# cal_filter
# Script to filter iCal entries, generating a new iCal feed with only the
# matching items

require 'rubygems'
require 'time'
require 'net/http'
require 'net/https'
require 'ri_cal'
require 'optparse'
require 'optparse/time'
require 'pp'
#require 'time_start_and_end_extensions'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: cal_filter.rb [options] [ical file]\nTakes an ical feed either as a file in the last parameter or from stdin, filters it according to to the given parameters and output a new ical feed on stdout"

  opts.on("-h", "--help", "Print this help message") do
    puts opts
    exit
  end
  opts.on("-s", "--summary [REGEXP]", Regexp, "Search the summary for the given string") do |reg|
    options[:summary] = reg
  end
  opts.on("-l", "--location [REGEXP]", Regexp, "Search the location for the given string") do |reg|
    options[:location] = reg
  end
  opts.on("-d", "--description [REGEXP]", Regexp, "Search the description for the given string") do |reg|
    options[:description] = reg
  end
  opts.on("-b", "--before [DATE]", Time, "Match events before the given date") do |date_when|
    options[:before] = date_when
  end
  opts.on("-a", "--after [DATE]", Time, "Match events after the given date") do |date_when|
    options[:after] = date_when
  end
  opts.on("-v", "--invert", "Invert the filter, rather than keeping items that match, only keep items that don't match") do
    options[:invert] = true
  end
end.parse!

# Grab the data from stdin
# (ARGF will take contents of files pass in as arguments or, if no args, stdin
cal_data = ARGF.read

all_events = RiCal.parse_string(cal_data)

# Find any relevant events
all_events.each do |cal|
  unless options[:summary].nil?
    cal.events.delete_if do |ev|
      (options[:invert].nil? ^ ev.summary.match(options[:summary]))
    end
  end
  unless options[:location].nil?
    cal.events.delete_if do |ev|
      (options[:invert].nil? ^ ev.location.match(options[:location]))
    end
  end
  unless options[:description].nil?
    cal.events.delete_if do |ev|
      (options[:invert].nil? ^ ev.description.match(options[:description]))
    end
  end
  unless options[:before].nil?
    cal.events.delete_if do |ev|
      (options[:invert].nil? ^ (!ev.occurrences(:before => options[:before], :count => 1).empty?))
    end
  end
  unless options[:after].nil?
    cal.events.delete_if do |ev|
      (options[:invert].nil? ^ (!ev.occurrences(:starting => options[:after], :count => 1).empty?))
    end
  end
end

puts all_events

exit
# testing output after this
all_events.each do |cal|
  puts "### #{cal.events.size}"
  cal.events.each do |ev|
pp ev
exit
    puts "# #{ev.summary}"
    puts ">>#{ev.description}<<"
    puts "@ #{ev.location}"
  end
end
