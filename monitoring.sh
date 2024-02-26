#!bin/bash

#Ram info
Memused=$(free --mega| grep Mem | awk '{print $3}')
Memtotal=$(free --mega| grep Mem | awk '{print $2}')

#Disk info
diskuse=$(df -P  --total | tail -1 | awk '{printf("%d", $3/1000) }')
disktotal=$(df -P -h --total | tail -1 | awk '{print $2}')
diskpercent=$(df -P -h --total | tail -1 | awk '{print $5}')
wall "	#Architecture:$(uname -a)
		#CPU physical : $(grep "physical id" /proc/cpuinfo | wc -l)
		#vCPU : $(nproc)
		#Memory Usage: $Memused/${Memtotal}MB($(free --mega| grep Mem | awk '{printf ("%.2f%", ($3/$2)*100)}'))
		#Disk Usage: ${diskuse}/${disktotal}b (${diskpercent})
		#CPU load: $(vmstat 1 2 | tail -1 | awk '{printf("%.1f%%", 100 -$15)}')
		#Last boot: $(who -b | awk '{print $3 " " $4}')
		#LVM use: $(if lsblk | grep -q "LVM"; then
			echo "yes"
		else
			echo "no"
		fi)
		#Connections TCP : $(ss | grep "tcp" | wc -l)  ESTABLISHED
		#User log: $(users | wc -w)
		#Network: IP $(hostname -I) ($(ip link | grep "link/ether" | awk '{print $2}'))
		#Sudo : $(journalctl | grep "COMMAND" | wc -l) cmd
	"
