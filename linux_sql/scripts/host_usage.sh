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

# Step 3: Collect usage data
vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n1 | xargs)
disk_io=$(vmstat -d | awk '{print $10}' | tail -n1 | xargs)
disk_available=$(df -BM / | grep '^/' | awk '{print $4}' | sed 's/M//')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Debugging lines
echo "Hostname: $hostname"
echo "Memory Free: $memory_free MB"
echo "CPU Idle: $cpu_idle"
echo "CPU Kernel: $cpu_kernel"
echo "Disk IO: $disk_io"
echo "Disk Available: $disk_available MB"
echo "Timestamp: $timestamp"

# Step 4: Construct the INSERT statement
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"
insert_stmt="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES ('$timestamp', $host_id, '$memory_free', '$cpu_idle', '$cpu_kernel', '$disk_io', '$disk_available');"

# Step 5: Execute the INSERT statement
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

# Exit with the status of the last command
exit $?
