#!/bin/bash

#Set env
work_hours="10:00-17:00"
data=$(date)
instance_id="i-00000000000000001"

#Parse time           
time=$(awk '{print $4}' <<< $data) 
data_time=$(awk '{print $4}' <<< $data)
start_time=$(awk '{split($0, arr, "-");  print arr[1]}' <<< $work_hours) 
stop_time=$(awk '{split($0, arr, "-");  print arr[2]}' <<< $work_hours) 

#Func convert to mil time
function parse_time(){
    time_h=$(awk '{split($0, arr, ":"); print arr[1]}'<<< $1)
    time_m=$(awk '{split($0, arr, ":"); print arr[2]}'<<< $1)
    time_h=${time_h#0}
    echo $time_h$time_m    
}

#aws handler
function ec2_start(){
    echo "aws_start"
    aws ec2 start-instances --instance-ids $1 --profile default
}
function ec2_stop(){
    echo "aws_stop"
    aws ec2 stop-instances --instance-ids $1 --profile default
}

#Convert to mil time
time=$(parse_time $data_time)
start=$(parse_time $start_time)
end=$(parse_time $stop_time)


#Time algorithm
if [[ $start -gt $end ]]
then
    if [[ $start -gt $time ]] && [[ $time -lt $end ]] || [[ $start -lt $time ]] && [[ $time -lt $end ]]
    then
        ec2_start $instance_id
    else
        ec2_stop $instance_id
    fi
elif [[ $start -lt $end ]] 
then 
    if [[ $start -gt $time ]] && [[ $time -gt $end ]]  || [[ $start -lt $time ]] && [[ $time -lt $end ]]
    then
        ec2_start $instance_id
    else
        ec2_stop $instance_id
    fi
else 
    ec2_stop $instance_id
fi