#!/bin/bash
if [[ -f "${dir}/livedomains.txt" ]]; then
  echo "Grabbing endpoints for $programName:" | notify -silent -bulk -id gaius
  katana -u "${dir}/livedomains.txt" -duc -silent -nc -jsl -kf -fx -xhr -ef woff,css,png,svg,jpg,woff2,jpeg,gif | anew -q "${dir}/endpoints.txt" >/dev/null
  # echo "Endpoint file created for $programName." | notify -silent -bulk -id thufir
else
  echo "No root domains found for $programName!" | notify -silent -bulk -id piter
  log_message "No domains found for endpoints.sh :: $programName"
fi
