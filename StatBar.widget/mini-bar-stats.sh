#!/bin/zsh

export TZ=$1
DISK=$2
DATE_DAY=$(date +%a)
DATE_MONTH=$(date +%b)
DATE_DAY_NUM=$(date +%d)
DATE_YEAR=$(date +%Y)
DATE_TIME=$(date +%H:%M)
DATE_AMPM=$(echo $_DATE | awk '{print $6}')
SSID=$(ipconfig getsummary en0 | awk '/\ SSID/{print $NF}')
WIFI_IP=$(ipconfig getifaddr $(networksetup -listallhardwareports | grep -A 1 "Wi-Fi" | sed -n '2 p' | awk '{ print $2 }'))
CPU_USAGE=$(printf "%.2f" $((100 - $(top -l1|awk '/CPU usage/{print $7}' | tr -d "%"))))
_MAX_MEMORY=$(sysctl hw.memsize | awk '{print $2}')
_PAGE_SIZE=$(vm_stat | grep "page size of" | awk '{print $8}')
_MEM_USED=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/.$//')
MEM_USAGE=$(echo "scale=2; $_MEM_USED * $_PAGE_SIZE / $_MAX_MEMORY * 100" | bc)
# get the disk usage as a percentage
DISK_USAGE=$(df -H | grep "$DISK" | awk '{print $5}' | cut -d% -f1)
cat <<EOF
{
  "date_day":"${DATE_DAY}",
  "date_month":"${DATE_MONTH}",
  "date_day_num":"${DATE_DAY_NUM}",
  "date_year":"${DATE_YEAR}",
  "date_time":"${DATE_TIME}",
  "ssid":"${SSID}",
  "wifi_ip":"${WIFI_IP}",
  "cpu_usage":"${CPU_USAGE}",
  "mem_usage":"${MEM_USAGE}",
  "disk_usage":"${DISK_USAGE}"
}
EOF
