#!/bin/sh
#


function set_key_secret_projectid
{
	echo ""
}

#
# issue a message on error exit
#

export sentry_exit_error_message="unknown error msg"

function issue_error_exit_message
{
    errcode=$?
    cmd=$BASH_COMMAND
    if [[ $errcode != 0 ]] ; then
        let entry=${#BASH_LINENO[@]}-2
        line=${BASH_LINENO[entry]}
        stack=${BASH_LINENO[@]}
        capture_error "on_error_exit: $sentry_exit_error_message (cmd=$cmd, stack=$stack)" "fatal" $line
    fi
    exit $errcode
}

function on_error_exit {
    export sentry_exit_error_message="$@"
    trap issue_error_exit_message EXIT
}

#
# setter for release
#

function set_release
{
  echo ""
}

SCRIPT_ARGUMENTS=$@


# Default level
#
# Acceptable level values are:
#
#  fatal
#  error
#  warning
#  info
#  debug

LEVEL="warning"  

# print the right color for each level
#
# Arguments:
# 1:  level
#

function sentry_color
{
    priority=$1
    if [[ $priority == "fatal" ]] ; then
        echo -e "\033[31m"
    elif [[ $priority == "error" ]] ; then
        echo -e "\033[34m"
    elif [[ $priority == "warning" ]] ; then
        echo -e "\033[35m"
    elif [[ $priority == "info" ]] ; then
        echo -e "\033[36m"
    elif [[ $priority == "debug" ]] ; then
        echo -e "\033[37m"
    else
        echo -e "\033[32m";
    fi
}

defaultcolor="\033[30m"

#   ----------------------------------------------------------------
#   Function for exit due to fatal program error
#   Arguments:
#       - string containing descriptive error message
#       - Line_ at caller
#
#
#   ---------------------------------------------------------------- 

function error_exit
{
    stack=${BASH_LINENO[@]}
    capture_error "error_exit: ${1:-'Unknown Error'} (stack=$stack)" "fatal" ${2:-"unknown line"}
    exit 1
}

#   ----------------------------------------------------------------
#   Function to log an error
#   Arguments:
#       - string containing descriptive error message
#       - Line_ at caller
#
#
#   ---------------------------------------------------------------- 

function log_error
{
    stack=${BASH_LINENO[@]}
    capture_error "log_error: ${1:-'Unknown Error'} (stack=$stack)" "error" ${2:-"unknown line"}
}


#   ----------------------------------------------------------------
#   Function to log a warning
#   Arguments:
#       - string containing descriptive error message
#       - Line_ at caller
#
#
#   ---------------------------------------------------------------- 

function log_warning
{
    stack=${BASH_LINENO[@]}
    capture_error "log_warning: ${1:-'Unknown Warning'} (stack=$stack)" "warning" ${2:-"unknown line"}
}

# Arguments
#   - 1: error message
#   - 2: level
#   - 3: line number


capture_error()
{
        echo -e "$2: $(sentry_color $2) '$1' ${defaultcolor} (Line numer: '$3')"
}
