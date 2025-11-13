#!/bin/bash

cache_file="/tmp/cache/wttr_cache.txt"

if [ ! -f "$cache_file" ]; then
	mkdir -p "$(dirname "$cache_file")" # Create .cache directory if it doesn't exist
	touch "$cache_file"
fi

last_modified=$(stat -c %Y "$cache_file")
current_date=$(date +%s)
time_diff=$((current_date - last_modified))
expiry_time=86400
cached_data=$(<"$cache_file")

if [ $time_diff -lt $expiry_time ] && [ -n "$cached_data" ]; then
	echo "$cached_data"
	exit
fi

#Use your own city for accurate result or else just omit the variable 
#and it will give the weather report based on ip
location=Lalitpur+Nepal
response=$(curl "wttr.in/$location?format=%c+%C+%t" 2>/dev/null)
city=$response
echo "$city" >"$cache_file"