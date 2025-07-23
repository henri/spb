#!/usr/bin/env bash
#
# (C)2025 Henri Shustak
# Script will add the ~/bin/spb-update.bash script into the
# users crontab if it is not already present.
#
# This script is part of the spb project : 
# https://gist.github.com/henri/spb
#
# Licenced Under the GNU GPL v3 or later
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Note that this script currently adds the entry to the users crontab
# The output fromat of the inserted entry may not match the formatting of existing crontab entries
#
# version 1.0 - inital release
# version 1.1 - bug fixes
#

# configuration
spb_update_script_home_realitive="bin/spb-update.bash"
spb_update_script="$HOME/${spb_update_script_home_realitive}"
crontab_entry="0      3    *    *    2\t\t~/${spb_update_script_home_realitive}" # use echo -e to get the tab printing correctly
backup_crontab_entry="/tmp/crontab_backup_$(whoami)"

# variables
exit_status=0

function clean_exit () {
  rm -f ${backup_crontab_entry} >> /dev/null
  exit ${exit_status}
}

# create the crontab backup file and set permissions so only we can access the file.
touch ${backup_crontab_entry}
chmod 700 ${backup_crontab_entry}

# check if the script is executable and accessable
if ! [ -x "${spb_update_script}" ] ; then
     if ! [ -e "${spb_update_script}" ] ; then
         echo "ERROR! : The SPB update script is not executable : ${spb_update_script}"
         exit_status=8 ; clean_exit
     else
         echo "ERROR! : Unable to loate the SPB update script : ${spb_update_script}"
         exit_status=9 ; clean_exit
     fi
fi

# scan the users crontab to see if it is loaded (maybe in the future we will have different options)
crontab -l 2>/dev/null | grep -q "${spb_update_script}"
if [[ ${?} == 0 ]] ; then
    echo "SPB Update script is already laoded into the crontab"
    clean_exit
fi

# backup the users crontab
crontab -l > "${backup_crontab_entry}"

# install the spb-update.bash script into the crontab
 crontab - <<< $(crontab -l 2>/dev/null | grep -v "~/${spb_update_script_home_realitive}" ; echo -e "${crontab_entry}" ) 
# cat <<< $(crontab -l 2>/dev/null | grep -v "${spb_update_script}" ; echo "" ) 
cront_tab_modifiaction_exit_value=${?}

# report the situation
if [[ "${cront_tab_modifiaction_exit_value}" == 0 ]] ; then
    echo "          SPB update script has been added to your crontab."
    echo "          Show your crontab entires with the command : crontab -l "
    clean_exit
else
    echo "ERROR! : While attempting to add the SPB update script to your crontab."
    echo "         You should check your crontab is okay"
    echo ""
    echo "         A backup of your crontab was made before we tried to edit your crontab"
    echo "         ${backup_crontab_entry}"
    echo ""
    echo "         Check the crontab backup with the command : "
    echo "         cat ${backup_crontab_entry}"
    echo ""
    echo "         If the backup looks okay, you will be able to restore your crontab to formal glory with : "
    echo "         cat ${backup_crontab_entry} | crontab -"
    echo ""
    echo "         Finally, confirm your crontab has been restored with : "
    echo "         crontab -l "
    echo ""
    exit -99 # exit but leave the crontab backup file
fi
