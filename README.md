# calherder

Simple utilities to aid in processing iCal files.  Generally intended to be chained together as you would with simple Unix command line utilities, so they often take and/or output iCal text via stdin/stdout.

e.g to find all events with "Important" in their summary...

curl http://example.com/events.ical | cal_filter.rb -s Important

**Work in progress, use at own risk ;-)**

## Files

 * cal_filter.rb - grep for iCal files
 * cal_count.rb - list events between two dates
