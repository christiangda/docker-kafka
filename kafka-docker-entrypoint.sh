#!/bin/bash
set -x

for line in $(printenv | grep KAFKA__ | sed 's/KAFKA__//'); do
  key=${line%=*}
  value=${line#*=}
  #new_line=$(echo $key | tr '[:upper:]' '[:lower:]' | sed 's/_/./g')
  new_line=$(echo $key | tr '[:upper:]' '[:lower:]')
  echo $new_line
done
