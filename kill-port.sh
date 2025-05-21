#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <port_number>"
    exit 1
fi

if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Port number must be a positive integer"
    exit 1
fi

PID=$(lsof -ti :$1)

if [ -z "$PID" ]; then
    echo "No process found running on port $1"
    exit 0
fi

echo "Found process $PID running on port $1"
kill -9 $PID

if [ $? -eq 0 ]; then
    echo "Successfully killed process $PID"
else
    echo "Failed to kill process $PID"
    exit 1
fi
