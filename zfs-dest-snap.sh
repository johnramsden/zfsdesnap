#!/bin/sh
# Created by John Ramsden
# github: johnramsden

# Destroy all snapshots before a certain date based off name
# with date format +%Y-%m-%d-%H%M%S

# Options:
# -n: print what will happen but do nothing
# -a: ask before destroying
# -p: Add a prefix
# -r: Add a dataset
# -d: Date REQUIRED

# e.g. zdestsnap -n -p "pre-ins" -r "tank/home" -d "2016-06-07-155650"
# This will print what will happen to all snapshots of
# "tank/home" before"2016-06-07-155650"

beginswith() {
  case ${2} in
    "${1}"*) true
    ;;
    *) false
    ;;
  esac;
}

destsnap(){
  if [ ${ask} -eq 1 ]; then
    echo "Do you wish to destroy this snapshot?"
    read yn
    case $yn in
        [Yy]* ) echo "destroying ${1}";
          if [ ${testmode} -eq 0 ]; then
            zfs destroy "${1}"
            echo "DESTROYED: ${1}"
          fi
          echo
        ;;
        [Nn]* ) echo
        ;;
        * ) echo "Please answer yes or no."
        ;;
    esac
  else
    echo "destroying ${1}";
    if [ ${testmode} -eq 0 ]; then
      zfs destroy "${1}"
      echo "DESTROYED: ${1}"
    fi
  fi
}

checksnaps() {
  for snapshot in ${1}
  do
    snapdate=`echo "${snapshot}"  \
      | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{6}'  \
      | tr -d "-"`

    if  [ -n "${snapdate}" ] && [ "${snapdate}" -le "${destroydate}" ]; then
      if beginswith "${prefix}" `echo "${snapshot}" | sed "s:${dataset}@::"`; then
        echo
        echo "For snapshot: ${snapshot}"
        echo "${snapdate} is older than: ${destroydate}"
        echo "and begins with: ${prefix}"
        destsnap "${snapshot}"
      fi
    fi
  done

  # grep gets
  # -E Interpret PATTERN as an extended regular expression.
  # -o Show only the part of a matching line that matches PATTERN.
  # [[:digit:]] It will fetch digit only from input.
  # {N} It will check N number of digits in given string, i.e.: 4 for years 2 for months and days
}

#####################################
############# MAIN CODE #############
#####################################

ask="0"
testmode="0"

# disable the verbose error handling by preceding the whole option string with a colon (:):
while getopts ":nap:r:d:" opt; do
  case $opt in
    n)
      echo "Running in test mode, will not destroy anything"
      testmode="1"
      ;;
    a)
      echo "Running in ask before destroying mode."
      ask="1"
      ;;
    p)
      echo "Running with prefix: ${OPTARG}"
      prefix="${OPTARG}"
      ;;
    r)
      echo "Running with dataset: ${OPTARG}"
      dataset="${OPTARG}"
      ;;
    d)
      echo "Date: ${OPTARG}"
      datebefore="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      ;;
  esac
done

echo "${datebefore+set}"

if [ -n "${datebefore+set}" ]; then
  echo "Destroy before date was set to ${datebefore}"
  echo "Removing hyphens"
  destroydate=`echo "${datebefore}"  | tr -d "-"`
  echo "Destroydate: ${destroydate}"

  if [ -n "${dataset+set}" ]; then
    echo "Running on dataset ${dataset}"
    snaps=`zfs list -H -t snapshot -r "${dataset}" | cut -f 1`
    checksnaps "${snaps}"
  else
    echo "Running on all datasets"
    snaps=`zfs list -H -t snapshot | cut -f 1`
    checksnaps "${snaps}"
  fi
else
  echo 'Destroy before date was not set, please set a date using -d'
fi
