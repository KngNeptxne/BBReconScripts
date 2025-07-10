#!/bin/bash
if [[ -f "${dir}/alldomains.txt" ]]; then
  # echo "Resolving domains for $programName." | notify -silent -bulk gaius
  dnsx -l "${dir}/alldomains.txt" -rl 10 -silent | anew "${dir}/resolveddomains.txt" >/dev/null # | notify -silent -bulk -id thufir
else
  echo "No root domains found for $programName!" | notify -silent -bulk -id piter 
  log_message "No Domains Found for resolve.sh :: $programName"
fi
