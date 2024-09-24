#!/bin/bash

# Collect hardware specifications
hostname=$(hostname -f)
lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{print $2}')
cpu_architecture=$(echo "$lscpu_out" | grep "Architecture:" | awk '{print $2}')
cpu_model=$(echo "$lscpu_out" | grep "Model name:" | awk -F ': ' '{print $2}')
cpu_mhz=$(echo "$lscpu_out" | grep "CPU MHz:" | awk '{print $3}')
l2_cache=$(echo "$lscpu_out" | grep "L2 cache:" | awk '{print $3}' | sed 's/K//')
total_mem=$(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Print hardware specifications
echo "Hardware Specifications:"
echo "hostname=$hostname"
echo "cpu_number=$cpu_number"
echo "cpu_architecture=$cpu_architecture"
echo "cpu_model=$cpu_model"
echo "cpu_mhz=$cpu_mhz"
echo "l2_cache=$l2_cache"
echo "total_mem=$total_mem"
echo "timestamp=$timestamp"
echo

# Collect Linux resource usage data
memory_free=$(vmstat --unit M | tail -1 | awk '{print $4}')
cpu_idle=$(vmstat | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat | tail -1 | awk '{print $14}')
disk_io=$(vmstat -d | tail -1 | awk '{print $10}')
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's/M//')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Assume host_id is known or retrieved from a database
host_id=1

# Print resource usage data
echo "Resource Usage Data:"
echo "timestamp=$timestamp"
echo "host_id=$host_id"
echo "memory_free=$memory_free"
echo "cpu_idle=$cpu_idle"
echo "cpu_kernel=$cpu_kernel"
echo "disk_io=$disk_io"
echo "disk_available=$disk_available"
ec
