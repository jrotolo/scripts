#!/usr/bin/ruby
require 'togglv8'
require 'date'

$TOGGL_API = TogglV8::API.new('9a499ca9baf698bb432d7469208d6ec0')
$USER = $TOGGL_API.me(all=true)

$DATE = Date.today
$YEAR = $DATE.year
$MONTH = $DATE.mon
$DAY = $DATE.day

# Create a Time Entry in Toggl for a full day today
def single_day
	$TOGGL_API.create_time_entry({
		'pid' => '12822555',
		'duration' => 28800,
		'start' => $TOGGL_API.iso8601(DateTime.new($YEAR,$MONTH,$DAY,15,30,0)),
		'created_with' => 'Toggl Time Entry Script'
	})
end

# Creates a Time Entry in Toggl for a full day each day of the week
# FIXME: This would be run on a friday and would need to create entries for the
# past 5 days no the future 5 days
def full_week
	date = $DATE
	day = $DAY
	month = $MONTH
	year = $YEAR

	5.times do
		$TOGGL_API.create_time_entry({
			'pid' => '12822555',
			'duration' => 28800,
			'start' => $TOGGL_API.iso8601(DateTime.new(year,month,day,15,30,0)),
			'created_with' => 'Toggl Time Entry Script'
		})
		date = date.next_day
		day = date.day
		month = date.mon
		year = date.year
	end
end

if ARGV[0] == 'full_week'
	full_week
else
	single_day
end
