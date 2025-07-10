#!/bin/bash
# If nord is not connected, connect. Copy of nord.sh without env export. :

status=$(nordvpn status | head -n 1) # Sets the current status of nordvpn to a variable
retry=0 # counter to log reconnect attemps. If it hits 11 attemps notification will be sent to the discord. 

while [ "$status" = "Status: Disconnected" ]; do 
  nordvpn connect
  status=$(nordvpn status | head -n 1)
  if [[ $status == "Status: Disconnected" ]]; then
    log_message "Network error occured. Retrying in 5 seconds"
    for i in $(seq 5 -1 1); do
      echo $i
      sleep 1
    done
  fi
  #
  ((retry+=1))
  #
  
  if [[ $((retry%10)) -eq 0 ]] && [[ $retry -ne 0 ]] ; then 
    echo -e "CRITICAL NETWORK ERROR OCCURED.\nRetry count:: $retry.\nSeconds stuck in loop:: $((retry * 5))" | notify -silent -bulk -id piter
  fi
done
#
echo "Nord already connected."

