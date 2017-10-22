#!/usr/bin/env bash
set -e

# eval "declare -a array=$(get_env_vars_from_prefix 'KAFKA__')"
# echo ${array[2]}
# Thank you: Steve Zobell https://stackoverflow.com/questions/10582763/how-to-return-an-array-in-bash-without-using-globals/16843375#16843375
function get_env_vars_from_prefix {
  local prefix=$1
  local output=( $(printenv | grep ${prefix} | sed "s/${prefix}//" | sort ) )
  declare -p output | sed -e 's/^declare -a [^=]*=//'
}

# MY_CONF_KEY=MY_VALUE --> my.conf.key=MY_VALUE
function env_line_to_prop_line {
  local line=$1
  local key=${line%=*}
  local value=${line#*=}
  local new_key=$(echo ${key} | tr '[:upper:]' '[:lower:]' | sed 's/_/./g')
  local new_line=${new_key}\=${value}
  echo ${new_line}
}

# eval "declare -a array=$(env_array_to_prop_array ${some_array[@]})"
# echo ${array[2]}
function env_array_to_prop_array {
  local input=($@)
  local output=()
  local i=0
  for element in "${input[@]}"; do
    output[$i]=$(env_line_to_prop_line $element)
    let i+=1
  done
  declare -p output | sed -e 's/^declare -a [^=]*=//'
}

#
function write_to_file {
  local line=$1
  local file=$2
  echo "$line" >> $file
}

# some test
#eval "declare -a array_one=$(get_env_vars_from_prefix 'KAFKA__')"
#echo "Global var 2 is: ${array_one[2]}"
#eval "declare -a array_two=$(env_array_to_prop_array ${array_one[@]})"
#echo "Global var 2 is: ${array_two[2]}"
