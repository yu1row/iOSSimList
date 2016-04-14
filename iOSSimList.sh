#!/bin/sh

SIMULATOR_PROC=`ps xr -o command | grep [l]aunchd_sim`;
is_running() {
  udid=`/usr/libexec/PlistBuddy -c 'Print UDID' ${1}`;
  [[ “${SIMULATOR_PROC/$udid}” != “${SIMULATOR_PROC}” ]] && { echo 1; } || { echo 0; }
}

n_index=0
n_sim=-1
DEVICE_LIST=`find ~/Library/Developer/CoreSimulator/Devices/ -name device.plist`;
array=($DEVICE_LIST)
 for i in "${array[@]}"
 do
   [ `is_running ${i}` -eq 1 ] && { printf [x; n_sim=$n_index; } || { printf [%1s; }
   printf %-3d] $n_index
   let n_index++
   echo `/usr/libexec/PlistBuddy -c 'Print UDID' ${i}` - `/usr/libexec/PlistBuddy -c 'Print name' ${i}`'('`/usr/libexec/PlistBuddy -c 'Print runtime' ${i} | cut -c 36-99 | sed -e "s/-/./g"`')';
 done

echo
echo Please select a folder that you want to open[number or x]: 
read operation
expr $operation + 1 >/dev/null 2>&1
if [ $? -lt 2 ]; then
  [ $operation -ge 0 -a $operation -lt ${#array[@]} ] && { open ${array[operation]/device.plist}; }
elif [ "$operation" = "x" ]; then
  [ $n_sim -ge 0 ] && { open ${array[n_sim]/device.plist}; }
fi
