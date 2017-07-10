# calherder

Simple utilities to aid in processing iCal files.  Generally intended to be chained together as you would with simple Unix command line utilities, so they often take and/or output iCal text via stdin/stdout.

e.g to find all events with "Important" in their summary...

curl http://example.com/events.ical | cal_filter.rb -s Important

**Work in progress, use at own risk ;-)**

## Files

 * cal_filter.rb - grep for iCal files
 * cal_count.rb - list events between two dates

## Tips

 * [https://www.lifewire.com/how-to-export-all-your-google-calendar-data-1172176](https://www.lifewire.com/how-to-export-all-your-google-calendar-data-1172176) gives details on exporting **all** calendar data from Google Calendar (the ical link in the calendar settings only gives the past month or so)

## Examples

### Monthly Event Counts

1. Get a list of all the events and save them into a file.  Use `grep` to filter them accordingly if you need to omit some of the events (for example, the DoES Liverpool laser-cutter booking calendar has bank holidays and regular induction slots.  In order to just get real bookings, we can filter the results through `| grep ^booked` to only get actual bookings):
    `cal_count.rb events.ics > event_counts.csv`
1. Process the file to turn it into a proper CSV.  Open it in `vi` and then run this command (find all the lines containing 20 - this assumes they are all in the 21st century, it'll need changing to pull in the C20th, etc. - then pull out everything before the date (.*), the year (\d\d\d\d) and month (\d\d), as numbered fields (the \1, \2 and \3) and replace them with the first bit wrapped in quotes, then the year, then the month, then the full date, all separated by commas):
    `:g/20/s/\(.*\) \(\d\d\d\d\)\-\(\d\d\)/\"\1\",\2,\3,\2-\3/`


