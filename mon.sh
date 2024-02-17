#!/bin/bash

# Get OS architecture and kernel version
os_architecture=$(uname -m)
kernel_version=$(uname -r)

# Get number of physical processors
physical_processors=$(grep -c ^processor /proc/cpuinfo)

# Get number of virtual processors
virtual_processors=$(grep -c ^processor /proc/cpuinfo)

# Get current available RAM and its utilization rate
total_memory=$(free -m | awk '/^Mem:/{print $2}')
used_memory=$(free -m | awk '/^Mem:/{print $3}')
memory_utilization=$(awk "BEGIN {printf \"%.2f\", ${used_memory}/${total_memory} * 100}")

# Get disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')

# Get current utilization rate of processors
cpu_utilization=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Get date and time of last reboot
last_reboot=$(who -b | awk '{print $3, $4}')

# Check if LVM is active
lvm_status=$(lsblk | grep -q "lvm"; echo $?)
if [[ $lvm_status -eq 0 ]]; then
    lvm_active="yes"
else
    lvm_active="no"
fi

# Get number of active TCP connections
active_connections=$(netstat -ant | grep ESTABLISHED | wc -l)

# Get number of users
number_of_users=$(who | wc -l)

# Get IPv4 address and MAC address
ipv4_address=$(ip addr show | grep "inet " | awk '{print $2}' | grep -v "127.0.0.1" | head -n 1)
mac_address=$(ip addr show | grep "ether " | awk '{print $2}' | head -n 1)

# Get number of commands executed with sudo
sudo_commands=$(cat /var/log/auth.log* | grep -c sudo)

# Prepare the message
message="Broadcast message from root@$(hostname) ($(date +"%a %b %d %T %Y")):
#Architecture: $os_architecture $kernel_version
#CPU physical : $physical_processors
#vCPU : $virtual_processors
#Memory Usage: $used_memory/$total_memory MB ($memory_utilization%)
#Disk Usage: $disk_usage
#CPU load: $cpu_utilization%
#Last boot: $last_reboot
#LVM use: $lvm_active
#Connections TCP : $active_connections ESTABLISHED
#User log: $number_of_users
#Network: IP $ipv4_address ($mac_address)
#Sudo : $sudo_commands cmd"

# Broadcast the message using wall
echo "$message" | wall
