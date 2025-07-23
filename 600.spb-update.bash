#!/usr/bin/env bash
#
# (C)2025 Henri Shustak
# SPB Update Script
# This script will pull down and update
# the SPB project and fish snippits
#
# The intention of this script is that it is called via cron, launchd
# or some other mechanisim to automate the upgrade process.
#
# This script is part of the spb project :
# https://github.com/henri/spb
#
# Licenced Under the GNU GPL v3 or later
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# version 1.0 - initial release (basic logging to home directory)
# version 1.1 - added support for interactive tty detection
# version 1.2 - bug fixes
# version 1.3 - added a bypass parameter for the random delay
# version 1.4 - added support for starting an auto update and being able to monitor the log with tail
# version 1.5 - added additional information relating to log monitoring
# version 1.6 - added a usage page accessable via the --help flag
# version 1.7 - bug fixes
# version 1.8 - implimented timeout features (sometimes only if coreutils has been installed on system)
# version 1.9 - further improvments related to --no-delay option when used in conjunction with --auto-monitoring
# version 2.0 - minor help output information improvements
# version 2.1 - attempts to keep scroll back when viewing the log file with tail
# version 2.2 - updated the update URL
#

# check if we are running with a connected tty for input
# to run this script in auto-mode, use the command below :
#
# ~/bin/spb-update.bash < /dev/null
#
# run automated session answering defaults automatically
# and monitor output via tail - similar to the above but
# adds monitoring (look at function below for details) :
#
#  ~/bin/spb-update.bash --auto-monitoring
#

# lock file (one update at a time please)
lock_file="/tmp/spb-update-$(hostname)-$(whoami).lock"
if [ -e ${lock_file} ] ; then
    echo "ERROR! : Lock file detected.. update aborted! "
    echo "         ${lock_file}"
    exit -78
fi
touch ${lock_file} # create the lock file :)

# set an EXIT trap (basic to cover the lock file)
trap 'clean_exit' EXIT

# setup a clean exit strategy
exit_status=0

# setup tail runtime timeout value for --auto-monitoring option
which timeout >> /dev/null ; timeout_available=${?}
if [[ ${timeout_available} == 0 ]] ; then
    timeout_available="true"
else
    timeout_available="false"
fi
tail_runtime_timeout=15 # how long to wait when running tail
auto_update_proceed_timeout=60 # when you are asked a question

# this will tidy up the lock file if we exit
function clean_exit () {
    rm -f ${lock_file} > /dev/null
    if [[ ${exit_status} == 0 ]] ; then
        # disable the exit trap
        trap - EXIT
    fi
    # remove any old update scripts
    rm -f ~/bin/spb-update.bash.old.2delete
    exit ${exit_status}
}

function update_auto_answer () {
      echo ""
      echo "Starting SPB update process :" ; echo ""
      echo "  This update system is about to start in a non-interactive mode."
      echo "  During the SPB update the log will be displayed on screen." ; echo ""
      echo "  All options will be automatcially answered using DEFAULT options."
      echo ""
      sleep 0.5
      # provide an option to bottle out - unless --no-delay option was specified in addition to --auto-monitoring option
      if [[ "${auto_monitoring_start_delay}" == "yes" ]] ; then
          echo "  Automatically continuing in ${auto_update_proceed_timeout} seconds..."
          echo -n "  Do you wish to continue now? [Y/n] : " 
          read -t ${auto_update_proceed_timeout} auto_update_proceed
          if \
               [[ "${auto_update_proceed}" == "n" ]] || \
               [[ "${auto_update_proceed}" == "N" ]] || \
               [[ "${auto_update_proceed}" == "no" ]] || \
               [[ "${auto_update_proceed}" == "No" ]] || \
               [[ "${auto_update_proceed}" == "NO" ]] \
            ; then
               echo ""
               echo "    Understood.. Update aborted."
               echo ""
               exit_status=0
               clean_exit
          fi
      fi
      sleep 1
      echo "" ; echo ""
      echo "Starting up SPB update log monitoring system..."
      echo ""
      sleep 2
      # this could be more fancy and monitor the screen session / get the tail PID and auto kill but no we are not doing that.
      rm -f ${lock_file} # remove the lock
      # configure time out settings if it is available on this system
      timeout_command=""
      if [[ "${timeout_available}" == "true" ]] ; then
          timeout_command="timeout --foreground ${tail_runtime_timeout}s"
      fi
      # start a screen session and recursivily call this script, set enviroment varable to report how to exit tail and start the update monitoing with tail command to monintor the log file
      screen -dm -S "spb-update" bash -c "export SPB_UPDATE_AUTO_ANSWER=\"true\" ; sleep 1 ; ~/bin/spb-update.bash --no-delay </dev/null" && clear -x ; sleep 1; ${timeout_command} tail -n0 -f ~/bin/spb-update.log
      # exit as we have completed the run, no clean exit call as this will have been handled by the recursive call
      exit 0
}

# let the install script know that it was started via the update script
export SPB_UPDATE_SCRIPT_SKIP="true"

# if this variable is passed into the script then we will add a line explaining how to exit from tail at the end of the output
if [[ "${SPB_UPDATE_AUTO_ANSWER}" != "true" ]] ; then
    # SPB_UPDATE_SCRIPT_SKIP should be set to ture, if this script is launced via the update script
    SPB_UPDATE_AUTO_ANSWER="false"
fi

# parse arguments / parameters / options etc...
update_delay="yes"
auto_monitoring_start_delay="yes"
auto_monitoring="no"
for arg in "${@}"; do
if [[ "${arg}" == "--help" ]] || [[ "${arg}" == "-h" ]] ; then
        if [ -t 0 ] ; then # we are running interactivly
            echo "" ; echo ""
            echo "  This script is part of the SPB (start-private-browser) project :"
            echo "    - https://gist.github.com/henri/spb" ; echo "" ; echo ""
            echo "      Usage : " ; echo ""
            echo "             # Show this help message" ; echo ""
            echo "                 ~/bin/spb-update.bash --help" ; echo "" ; echo ""
            echo "             # Disable the random delay when running"
            echo "             # without a tty connected to stdin" ; echo ""
            echo "                 ~/bin/spb-update.bash --no-delay" ; echo "" ; echo ""
            echo "             # Run the script without a tty connected to stdin."
            echo "             # This will have the result of this script using"
            echo "             # default options rather than providing interactive"
            echo "             # prompts. Use this to simulate what will happen"
            echo "             # when run via a scuduling system such as cron" ; echo ""
            echo "                 ~/bin/spb-update.bash </dev/null" ; echo "" ; echo ""
            echo "             # Use when a tty is connected, but you would"
            echo "             # like the script to behave like no tty is"
            echo "             # connected. This ensures automatic selection"
            echo "             # of default options. In addition, this option"
            echo "             # will tail the ~/bin/spb-update.log file"
            echo "             # Finally it will also enable the --no-delay"
            echo "             # option behaviour specified above automatically"
            echo "             # on your behalf" ; echo ""
            echo "                 ~/bin/spb-update.bash --auto-monitoring" ; echo ""
            echo "             # Again when tty is connected ; if the --no-delay"
            echo "             # option is used in combination with the"
            echo "             # --auto-monitoring option, then the"
            echo "             # regular --no-delay behaivour is included, and"
            echo "             # in adition, no pre-flight delay will be offered"
            echo "             # in which you would normally be able to"
            echo "             # change your mind to abort (caution)" ; echo ""
            echo "                 ~/bin/spb-update.bash --auto-monitoring --no-delay" ; echo "" ; echo ""
            clean_exit
        fi
    fi
done
# one loop for each argument we are checking # not doing them together on purposes
# this argument is deliberatly checked after the --help argument
for arg in "${@}"; do
    # are we going to have a delay before we run the unattended update
    if [[ "${arg}" == "--no-delay" ]]; then
        update_delay="no"
        auto_monitoring_start_delay="no"
    fi
done
# one loop for each argument we are checking # not doing them together on purposes
# this argument is deliberatly checked after the --no-delay argument
for arg in "${@}"; do
    # are we going to run unattneded but monitor things
    if [[ "${arg}" == "--auto-monitoring" ]]; then
        auto_monitoring="yes"
        # recurssivly kick off this script in a screen session and monitor the logs with tail
        update_auto_answer
    fi
done


# set an EXIT trap
trap 'echo "" ; echo "Something went horribly wrong with the update script, please try again later!" ; echo "" ; exit_status=55 ; clean_exit' EXIT

if [ -t 0 ] && [[ "${SPB_UPDATE_AUTO_ANSWER}" != "true" ]] ; then
     echo "Interactive TTY detected. Running interactive update..."
    # update SPB
    /bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash)"
    exit_status=${?}
    clean_exit
fi

# just update things do not ask to overwrite files (danger will robbinson)
# we set this after we have gone past the interactive section so that we 
# now have auto-updates (default answer automatically) enabled.
export SPB_SKIP_OVERWRITE_CHECK="true"

# set an EXIT trap with logging to file
trap 'echo "Something went horribly wrong with the unattended update script, please try again later!" >> ${log_file} ; exit_status=55 ; clean_exit' EXIT

# preform exit if we hit an error 
set -e

# logging file (for now)...
log_file="$HOME/bin/spb-update.log"
log_file_temporary="$HOME/bin/spb-update.log.tmp"
log_file_truncated="no"

# check the log file size. 
if [[ -e ${log_file} ]] ; then
    if [[ $(du ${log_file} 2> /dev/null| awk '{print $1}') -ge 1000 ]] ; then
        # log is getting large, cut it down to size (trim down to around 500kilobytes and then start with the first entry)
        tail -c 500k ${log_file} | sed '1,/^------------------------------------------------------------------------$/d' > ${log_file_temporary}
        mv ${log_file_temporary} ${log_file}
        log_file_truncated="yes"
    fi
fi

# prevent exit if we hit an error and remove the EXIT trap
set +e

# only report success if we actually have success
update_exit_status=10

# report we are starting an update
echo "" >> ${log_file}
# carful the length of this next line is important for trimming the file when it is too large
echo "------------------------------------------------------------------------" >> ${log_file} 
echo "SPB auto update starting up..." >> ${log_file}
echo "$(date)" >> ${log_file}
if [[ "${log_file_truncated}" == "yes" ]] ; then
    echo "FYI : Log file has been truncated to save space. The oldest data is no longer available."  >> ${log_file}
fi
echo "Running in non-interactive mode..." >> ${log_file}
if [[ "${update_delay}" == "yes" ]] ; then
    random_update_delay=$(max_random=80 ; ((random_value=$RANDOM%$max_random)) ; echo $random_value)
    echo "Random update delay ${random_update_delay} (seconds)... " >> ${log_file}
    sleep ${random_update_delay}
else
    echo "Random update delay... [skipped] " >> ${log_file}
fi
echo "SPB auto update running..." >> ${log_file}
echo "$(date)" >> ${log_file}
start_epoch="$(date +%s)"

# check the update script is accessable
script_accessable=$(curl -fsSL \
-o /dev/null -w "%{http_code}" \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash 2> /dev/null)

# convert a 200 code into a 0 code.
if [[ ${script_accessable} == 200 ]] ; then script_accessable=0 ; fi

# not a perfect check this could be improved...
if [[ ${script_accessable} == 0 ]] ; then
    
    # update SPB
    /bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash)" 2>&1 >> ${log_file}
update_exit_status=${PIPESTATUS[0]}
exit_status=${update_exit_status}

fi


end_epoch="$(date +%s)"
total_run_time=$(( end_epoch - start_epoch))

# report total run time
echo "$(date)" >> ${log_file} 
echo "Total Update Execution Time (in seconds) : ${total_run_time}" >> ${log_file}

# report outcome of update
if [[ ${update_exit_status} == 0 ]] ; then
    echo "SPB Update Completed." >> ${log_file}
else
    if [[ ${script_accessable} == 0 ]] ; then
        echo "ERROR! : Internal update script failed!" >> ${log_file}
    else
        echo "ERROR! : Unable to access the remote SPB update script!" >> ${log_file}
    fi
    echo "SPB Update Failed." >> ${log_file}
    exit_status=19
fi
if [[ "${SPB_UPDATE_AUTO_ANSWER}" == "true" ]] ; then
    echo "" >> ${log_file}
    echo "Script initiated with \"--auto-monitoring\" parameter." >> ${log_file}
    echo "The above data has been read from : ~/bin/spb-update.log" >> ${log_file}
    if [[ "${timeout_available}" == "true" ]] ; then
        echo "Auto exit in ${tail_runtime_timeout}s" >> ${log_file}
    fi
    echo "Press 'control-c' to exit now." >> ${log_file}

fi
# exit with the exit values from the update
clean_exit

