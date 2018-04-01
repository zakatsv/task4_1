#!/bin/bash

out_file="$(dirname $(readlink -f $0))/task4_1.out"
#dmi="dmidecode -s"
#mb="`$dmi baseboard-manufacturer` / `$dmi baseboard-product-name` / `$dmi baseboard-version`"
#pattern='^(\s/\s){2}$'
#[[ $mb =~ $pattern ]] && mb="Unknown"
bb_man=$(dmidecode -s baseboard-manufacturer)
bb_prod=$(dmidecode -s baseboard-product-name)
ssn=$(dmidecode -s system-serial-number)

echo "--- Hardware ---
CPU: $(lscpu | grep -oP "Model name:\s*\K.*")
RAM: $(free -h | awk '/Mem/{print $2"B"}')
Motherboard: ${bb_man:-Unknown} ${bb_prod}
System Serial Number: ${ssn:-Unknown}
--- System ---
OS Distribution: $(lsb_release -d | cut -f2)
Kernel version: $(uname -r)
Installation date: $(ls -ld /var/log/installer/ | awk '{if($8 ~ /[0-9]{4}/)print $6,$7,$8; else print $6,$7}')
Hostname: $(hostname)
Uptime: $(uptime -p | grep -oP "up\s\K.*")
Processes running: $(ps aux --no-heading | wc -l)
Users logged in: $(users | wc -w)
--- Network ---
$(ip -4 -o a | awk '{printf "%s: %s\n", $2, $4}'; ip -o a | awk '/inet /{a[$2]=$4; next}{a[$2]}END{for(i in a){if(a[i] == "")printf "%s: -\n", i}}')" > "${out_file}"
