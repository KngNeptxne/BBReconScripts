#!/bin/bash
# If nord is not connected, connect

# Will set the home directory to root if script is ran as root.
if [[ $EUID -eq 0 ]]; then
    export HOME=/root
fi

status=$(nordvpn status | head -n 1) # Sets the current status of nordvpn to a variable
# echo $status
if [[ $status == "Status: Disconnected" ]]; then
  echo "Nord connecting."
  nordvpn connect
else
  echo "Nord already connected."
  echo "NORD:: $status"
fi
