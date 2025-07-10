#!/bin/bash

# date +%m%d%y :: use for log file name

if [[ $EUID -eq 0 ]]; then
    export HOME=/root
fi

log_message() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] :: $1" # >> $logDir
}

source nordRecon.sh

echo "REST OF THE SCRIPT"



