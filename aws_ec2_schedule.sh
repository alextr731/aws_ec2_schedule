#!/bin/bash
# IMPORTANT
# Format for work is: 10:00-17:00

# work_hours="23:26-23:28"
# instance_id="i-0310fca271e362ad4"


work_hours=$1
instance_id=$2

#0. step installing at
echo "Installing at"
sudo apt-get install -y at 

#1. Parse Working hour
start=$(awk '{split($0, arr, "-");  print arr[1]}' <<< $work_hours) 
stop=$(awk '{split($0, arr, "-");  print arr[2]}' <<< $work_hours) 

#2. Set start and stop time
echo "start-$start stop-$stop" instance: $instance_id >> log_aws.txt
echo "aws ec2 start-instances --instance-ids $instance_id --profile default" | at ${start} 
echo "aws ec2 stop-instances --instance-ids $instance_id --profile default" | at ${stop} 

echo "Show planning tasks:"
at -l



