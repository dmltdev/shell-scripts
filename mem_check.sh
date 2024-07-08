#!/bin/bash

# Get the list of all systemd services
services=$(systemctl list-units --type=service --no-pager --no-legend | awk '{print $1}')

# Iterate through each service and print its PID and memory usage
for service in $services; do
    pid=$(systemctl show -p MainPID --value $service)
    if [ -n "$pid" ] && [ "$pid" -ne 0 ]; then
        rss_kb=$(ps -q $pid -o rss=)
	rss_mb=$(echo "scale=2; $rss_kb / 1024" | bc)
        echo "Service: $service, PID: $pid, RSS: ${rss_mb}MB"
    fi
done
