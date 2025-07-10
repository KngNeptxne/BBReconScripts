#!/bin/bash

# date +%m%d%y :: use for log file name

if [[ $EUID -eq 0 ]]; then
    export HOME=/root
fi
# Variables 
baseDir="/opt/bugbounty"
logDate="$(date +"%m%d%y")"
logFile="$logDate.log"
logDir="$baseDir/.logs/$logFile"
z="$(timedatectl | head -n 1)"
timeStart="${z:27}"
# Functions 
log_message() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] :: $1" >> $logDir
}
log_message "****** $PATH ******"
# Redundant check to ensure the VPN is connected before beginning the rest of the script.
source nordRecon.sh

if ! [[ -f "$logDir" ]]; then
  touch $logDir
  echo -e "Logfile created for today: $logDate\nStarting reconnaissance." | notify -silent -bulk -id gaius
  echo -e "Start of log for::\n$timeStart\n\n" >> $logDir
else
  echo -e "Logfile already exists." | notify -silent -id gaius
fi

if [[ -d "$baseDir" ]]; then
  for dir in "$baseDir"/*/; do
    programName=$(basename "$dir")
    if [[ -f "${dir}/roots.txt" ]]; then 
      #
      log_message "*** Starting $programName ***"
      #
      log_message "Starting subfinder."
      subfinder -dL "${dir}/roots.txt" -silent -rl 1 | anew "${dir}/alldomains.txt" >/dev/null
      echo "Domains found for $programName :: $(wc -l < ${dir}/alldomains.txt)" | notify -silent -bulk -id thufir
      head -n 5 "${dir}/alldomains.txt" | notify -silent -bulk -id thufir && log_message "Subfinder completed."
      #
      log_message "Starting resolve.sh."
      source resolve.sh
      echo "Resolved domains found for $programName :: $(wc -l < ${dir}/resolveddomains.txt)" | notify -silent -bulk -id thufir
      head -n 5 "${dir}/resolveddomains.txt" | notify -silent -bulk -id thufir && log_message "Finished resolve.sh."
      #
      log_message "Starting httpx."
      httpx -l "${dir}/resolveddomains.txt" -t 10 -rl 1 -silent -title -ip -sc -td -fr | anew "${dir}/livedomains.txt" >/dev/null
      echo "Live domains found for $programName :: $(wc -l < ${dir}/livedomains.txt)" | notify -silent -bulk -id thufir
      head -n 5 "${dir}/livedomains.txt" | notify -silent -bulk -id thufir && log_message "Httpx completed."
      #
      log_message "Finding Ports."
      smap -iL "${dir}/resolveddomains.txt" | anew "${dir}/openports.txt" >/dev/null 
      echo "Ports detected for $programName :: $(wc -l < ${dir}/openports.txt)" | notify -silent -bulk -id thufir
      head -n 5 "${dir}/openports.txt" | notify -silent -bulk -id thufir && log_message "Smap completed."
      #
      log_message "Starting endpoints.sh"
      source endpoints.sh
      echo "Endpoints found for $programName :: $(wc -l < ${dir}/endpoints.txt)" | notify -silent -bulk -id thufir
      head -n 5 "${dir}/endpoints.txt" | notify -silent -bulk -id thufir && log_message "Finished endpoints.sh."
      #
      timeCurrent="$(timedatectl | head -n 1)"
      echo "Recon.sh @$programName has completed succesfully @ ${timeCurrent:15}" | notify -silent -bulk -id gaius && log_message "Finished $programName."
    else
      echo "No root domains found for $programName!" | notify -silent -bulk -id piter && log_message "No domains found for $programName."
    fi
  done
  log_message "Recon loop has finished."
else
  echo "Directory '$baseDir' does not exist." | notify -silent -bulk -id piter && log_message "$baseDir NOT found."
fi
timeCurrent="$(timedatectl | head -n 1)"

echo "Script finished @ ${timeCurrent:15}" | notify -silent -bulk -id gaius && log_message "Script completed."

