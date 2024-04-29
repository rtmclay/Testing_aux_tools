#!/bin/bash
# -*- shell-script -*-
SCRIPT_NAME="${BASH_SOURCE[0]:-${(%):-%x}}"
SCRIPT_DIR=${SCRIPT_NAME%/*}

if [ $SCRIPT_DIR = "." ]; then
  SCRIPT_DIR=$PWD
fi  

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
  export PATH=$SCRIPT_DIR/bin:$PATH
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
  elif [ -n "$(find . -maxdepth 1 -name '*.*desc')" ]; then
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

