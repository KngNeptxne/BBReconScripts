#!/bin/bash

# date +%m%d%y :: use for log file name

# Variables 
#baseDir="/opt/bugbounty"
logDate="$(date +"%m%d%y")"
logFile="$logDate.log"
logDir="$baseDir/.logs/$logFile"
z="$(timedatectl | head -n 1)"
timeStart="${z:27}"
 
echo "Supply a directory:\n"
read baseDir

# # Redundant check to ensure the VPN is connected before beginning the rest of the script.
source nordRecon.sh

if [[ -d "$baseDir" ]]; then
  for dir in "$baseDir"/*/; do
    programName=$(basename "$dir")
    if [[ -f "${dir}/roots.txt" ]]; then 
      
      #subfinder -dL "${dir}/roots.txt" -silent -rl 1 | anew "${dir}/alldomains.txt" >/dev/null
      #echo "Domains found for $programName :: $(wc -l < ${dir}/alldomains.txt)" 
      #head -n 5 "${dir}/alldomains.txt" 
      #
      
      source resolveSolo.sh
      echo "Resolved domains found for $programName :: $(wc -l < ${dir}/resolveddomains.txt)" 
      head -n 5 "${dir}/resolveddomains.txt" 
      #
      
      httpx -l "${dir}/resolveddomains.txt" -t 10 -rl 1 -silent -title -ip -sc -td -fr | anew "${dir}/livedomains.txt" >/dev/null
      echo "Live domains found for $programName :: $(wc -l < ${dir}/livedomains.txt)" 
      head -n 5 "${dir}/livedomains.txt" 
      #
      
      smap -iL "${dir}/resolveddomains.txt" | anew "${dir}/openports.txt" >/dev/null 
      echo "Ports detected for $programName :: $(wc -l < ${dir}/openports.txt)"
      head -n 5 "${dir}/openports.txt" 
      #
      
      source endpointsSolo.sh
      echo "Endpoints found for $programName :: $(wc -l < ${dir}/endpoints.txt)"
      head -n 5 "${dir}/endpoints.txt" 
      #
      timeCurrent="$(timedatectl | head -n 1)"
      echo "Recon.sh @$programName has completed succesfully @ ${timeCurrent:15}" 
    else
      echo "No root domains found for $programName!"
    fi
  done
else
  echo "Directory '$baseDir' does not exist."
fi
timeCurrent="$(timedatectl | head -n 1)"

echo "Script finished @ ${timeCurrent:15}"
