#!/bin/bash
PROC=$1
BEND=$2
NEVT=$3

# Define the command to capture the output
output=$(cat $PROC-EVTGEN.MULTIBACKEND-$BEND-$NEVT/job.*.err)

# Filter the lines containing "real
filtered_output=$(echo "$output" | grep "^real" | sed 's/real\t//')

# Save the filtered output to a file
echo "$filtered_output"


