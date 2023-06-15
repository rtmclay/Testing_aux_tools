#!/bin/bash
# -*- shell-script -*-

LOC=$0
if [ -n "${BASH_SOURCE:-}" ]; then
  LOC=$BASH_SOURCE
fi

if [ "$LOC" = "testing_tools_shell_funcs.sh" -o "$LOC" = "./testing_tools_shell_funcs.sh" ]; then
   LOC=$PWD/try.sh
fi  

DIR="${LOC%/*}"
first=${DIR:0:1}
if [ $first != '/' ]; then
   DIR=$PWD/$DIR
fi
DIR=$(echo $DIR | sed -e 's|//\+|/|g' -e 's|/\./|/|g' -e 's|/\.$||' -e 's|/$||')

if [ -n "${ZSH_VERSION:-}" ]; then
   type()
   {
     if [ "$1" = "-p" ]; then
       shift 1
       whence "$@"
     else
       whence -vf "$@"
     fi
   }
fi


type td_cmd > /dev/null 2>&1
if [ "$?" != 0 ]; then
  export PATH=$DIR/bin:$PATH
fi

function bannerMsg ()
{
  local RED=$'\033[1;31m'
  local NONE=$'\033[0m'
  echo ""
  echo "${RED}=======================================================================${NONE}"
  echo $1
  echo "${RED}=======================================================================${NONE}"
  echo ""
}

function up ()
{
  [ $(( ${1:-1} + 0 )) -gt 0 ] && cd $(eval "printf '../'%.0s {1..$1}") && pwd 
}

function rs ()
{
  run_script "$@"
}

function run_script ()
{
  if [ -d t1 ]; then
    bannerMsg "$PWD: rm -rf t1; t ."
    rm -rf t1; t .
  elif [[ -f *.tdesc || -f *.desc ]]; then
    bannerMsg "$PWD: t ."
    t .
  elif [ -f ./${t1:-t1}.script ]; then
    ( . ./${t1:-t1}.script ) 2>&1 | tee ${t1:-t1}.log 
    [ -f results.csv ] && cat results.csv
  else
    echo "Wrong directory!"
  fi
}

function td () {
  eval "$(td_cmd)"
}

