#!/bin/bash

# Step 1: Assign CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Step 2: Check the number of arguments
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Step 3: Collect hardware specifications
hostname=$(hostname -f)
cpu_number=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
cpu_architecture=$(lscpu | grep "Architecture" | awk '{print $2}')
cpu_model=$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)
cpu_mhz=$(lscpu | grep -m 1 "CPU MHz" | awk '{print $NF}')
if [ -z "$cpu_mhz" ]; then
    cpu_mhz=$(grep -m 1 "cpu MHz" /proc/cpuinfo | awk '{print $4}')
fi
l2_cache=$(lscpu | grep "L2 cache" | awk '{print $3}' | sed 's/K//')
total_mem=$(cat /proc/meminfo | grep "MemTotal" | awk '{print $2}')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Debugging lines
echo "Hostname: $hostname"
echo "CPU Number: $cpu_number"
echo "CPU Architecture: $cpu_architecture"
echo "CPU Model: $cpu_model"
echo "CPU MHz: $cpu_mhz"
echo "L2 Cache: $l2_cache"
echo "Total Memory: $total_mem"
echo "Timestamp: $timestamp"

# Step 4: Construct the INSERT statement
insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp)
VALUES ('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$total_mem', '$timestamp');"

# Step 5: Execute the INSERT statement
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

# Exit with the status of the last command
exit $?
