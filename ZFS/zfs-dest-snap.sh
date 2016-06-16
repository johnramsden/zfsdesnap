#!/bin/sh

# Destroy all snapshots with prefix ${1} after date ${2}
# with date format +%Y-%m-%d-%H%M%S

beginswith() {
  #echo "Testing if ${2} beginswith ${1}"
  case ${2} in
    "${1}"*) true
    ;;
    *) false
    ;;
  esac;
}

dataset="${1}"
prefix="${2}"
# Remove hyphen frome date +%Y-%m-%d-%H%M%S
destroydate=`echo "${3}"  | tr -d "-"`

for snapshot in `zfs list -H -t snapshot -r "${dataset}" | cut -f 1`
do
  snapdate=`echo "${snapshot}"  \
    | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{6}'  \
    | tr -d "-"`

  if  [ -n "${snapdate}" ] && [ "${snapdate}" -le "${destroydate}" ]; then
    if beginswith "${prefix}" `echo "${snapshot}" | sed "s:${dataset}@::"`; then
      echo "For snapshot: ${snapshot}"
      echo "${snapdate} is older than ${destroydate}"
      echo "and begins with ${prefix}"
      echo

      read -p "Do you wish to destroy this snapshot?" yn
      case $yn in
          [Yy]* ) echo "destroying ${snapshot}";
            echo "Des"
          ;;
          [Nn]* )
          ;;
          * ) echo "Please answer yes or no."
          ;;
      esac
    fi
  fi
done

# grep gets
# -E Interpret PATTERN as an extended regular expression.
# -o Show only the part of a matching line that matches PATTERN.
# [[:digit:]] It will fetch digit only from input.
# {N} It will check N number of digits in given string, i.e.: 4 for years 2 for months and days
