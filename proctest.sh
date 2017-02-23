#!/bin/bash

# --------------------------------------------------------------------------- #
# Developer: Andrew Kirfman                                                   #
# Project: CSCE-313 Machine Problem #3                                        #
#                                                                             #
# File: ./proctest.sh                                                         #
# --------------------------------------------------------------------------- #

# Forward declare the PID variable
PID=""

# Need to filter program so that only the functions are defined on a test
TESTING=false
if [ $# -gt 0 ]
then
    TESTING=true
fi

function getpid()
{
    grep -Po "(?<=^Pid:\t).*" /proc/$PID/status;
}

function getppid()
{
    grep -Po "(?<=^PPid:\t).*" /proc/$PID/status;
}

function geteuid()
{
    grep -Po "(?<=^Uid:\t).*" /proc/$PID/status | cut -f2;   
}

function getegid()
{
    grep -Po "(?<=^Gid:\t).*" /proc/$PID/status | cut -f2;   
}

function getruid()
{
    grep -Po "(?<=^Uid:\t).*" /proc/$PID/status | cut -f1;   
}

function getrgid()
{
    grep -Po "(?<=^Gid:\t).*" /proc/$PID/status | cut -f1;   
}

function getfsuid()
{
    grep -Po "(?<=^Uid:\t).*" /proc/$PID/status | cut -f4;   
}

function getfsgid()
{
    grep -Po "(?<=^Gid:\t).*" /proc/$PID/status | cut -f4;   
}

function getstate()
{
    grep -Po "(?<=^State:\t).*" /proc/$PID/status;
}

function getthread_count()
{  
    grep -Po "(?<=^Threads:\t).*" /proc/$PID/status;
}

function getpriority()
{
    awk '{print $18}' /proc/$PID/stat;
}

function getniceness()
{
    awk '{print $19}' /proc/$PID/stat;
}

function getstime()
{
    awk '{print $15}' /proc/$PID/stat;
}

function getutime()
{
    awk '{print $14}' /proc/$PID/stat;
}

function getcstime()
{
    awk '{print $17}' /proc/$PID/stat;
}

function getcutime()
{
    awk '{print $16}' /proc/$PID/stat;
}

function getstartcode()
{
    awk '{print $26}' /proc/$PID/stat;
}

function getendcode()
{
    awk '{print $27}' /proc/$PID/stat;
}

function getesp()
{
    awk '{print $29}' /proc/$PID/stat;
}

function geteip()
{ 
    awk '{print $30}' /proc/$PID/stat;
}

function getfiles()
{
    ls /proc/$PID/fdinfo | wc -l;
}

function getvoluntary_context_switches()
{
    grep -Po "(?<=^voluntary_ctxt_switches:\t).*" /proc/$PID/status;
}

function getnonvoluntary_context_switches()
{
    grep -Po "(?<=^nonvoluntary_ctxt_switches:\t).*" /proc/$PID/status;
}

function getlast_cpu()
{
    awk '{print $39}' /proc/$PID/stat;
}

function getallowed_cpus()
{
    grep -Po "(?<=^Cpus_allowed_list:\t).*" /proc/$PID/status;
}

function getmemory_map()
{
    cat /proc/$PID/maps;
}

# Main program here
if [ $TESTING == false ]
then
    # Read in the value of the pid that the user would like to examine.  
    printf "Enter the pid of a process: " 
    read PID

    # If the value entered is not an integer, try again.  
    while ! [ "$PID" -eq "$PID" ] 2>/dev/null
    do
        printf "[ERROR]: Number was not a valid integer.  Try again: " 
        read PID
    done

    # Search the system to make sure that the process exists.  
    ls "/proc/$PID" > /dev/null
    if [ $? == 1 ]
    then
        echo "[ERROR]: A Process with the given ID does not exist on this system! - Exiting!"
        exit 1
    fi

    printf "\nProcess Information: " 
    
    printf "\n1) Identifiers\n"
    printf "   PID:   $(getpid) \n"
    printf "   PPID:  $(getppid) \n"
    printf "   EUID:  $(geteuid) \n"
    printf "   EGID:  $(getegid) \n"
    printf "   RUID:  $(getruid) \n"
    printf "   RGID:  $(getrgid) \n"
    printf "   FSUID: $(getfsuid) \n"
    printf "   FSGID: $(getfsgid) \n"
    
    printf "\n2) State: \n"
    printf "   State: $(getstate)\n"
    
    printf "\n3) Thread Information: \n"
    printf "   Thread Count: $(getthread_count) \n"
    
    printf "\n4) Priority: \n"
    printf "   Priority Number: $(getpriority) \n"
    printf "   Niceness Value:  $(getniceness) \n"
    
    printf "\n5) Time Information: \n"
    printf "   stime:  $(getstime) \n"
    printf "   utime:  $(getutime) \n"
    printf "   cstime: $(getcstime) \n"
    printf "   cutime: $(getcutime) \n"
    
    printf "\n6) Address Space: \n"
    printf "   Startcode: $(getstartcode) \n"
    printf "   Endcode:   $(getendcode) \n"
    printf "   ESP:       $(getesp) \n"
    printf "   EIP:       $(geteip) \n"
    
    printf "\n7) Resourses: \n"
    printf "   File Handles: $(getfiles) \n"
    printf "   Voluntary Context Switches: $(getvoluntary_context_switches)\n"
    printf "   Involuntary Context Switches: $(getnonvoluntary_context_switches)\n"
    
    printf "\n8) Processors: \n"
    printf "   Last processor: $(getlast_cpu) \n"
    printf "   Allowed Cores:  $(getallowed_cpus) \n"
        
    printf "\n9) Memory Map: \n"
    printf "$(getmemory_map) \n"

    exit 0
fi
