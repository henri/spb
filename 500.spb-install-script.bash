#!/usr/bin/env bash
#
# (C)Copyright Henri Shustak 2025
# Licenced Under the GNU GPL v3 or later
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Simple build script to install 
# the start-private-browser.bash
# and setup an alias within your
# shell - automatical styles !!!
#
# This script downloads spb files from this URL : 
# https://gist.github.com/henri/34f5452525ddc3727bb66729114ca8b4/
# 
# Once this script has successfully exectued, start a private browser with this command : 
# ~/bin/start-private-browser.bash
# 
# Initial release only supports zsh, fish and bash shell alias printing.
# Pull requests for other shell alias support bug fixes / reports welcome.
# Additional shells and further automation support will be added as time permits.
# 
# version 1.0 - Initial Release
# version 1.1 - Added BASH shell alias setup output
# version 1.2 - Shallow clone (seems like a good idea)
# version 1.3 - Improved output somewhat specific to insalled shells displayed
# version 1.4 - Implimented additional error detection prior to temporary build directory deletion 
# version 1.5 - Added enviroment variable to skip file overwriting (useful for automated upgrades)
# version 1.6 - Minor bug fix
# version 1.7 - Added ZSH shell alias setup output
# version 1.8 - Basic version reporting added
# version 1.9 - Implimented additional error checking and handling of unexpected conditions
# version 2.0 - Added additional output regarding the path of the file which if this is an upgrade
# version 2.1 - Dependency check added for git
# version 2.2 - Fixes to git dependency check messages
# version 2.3 - Added FISH alias function suggestion for spb -> start-private-browser
# version 2.4 - Added auto macOS /etc/defaults/periodic.conf edit option to prevent auto deletion spb browser directories" 
# version 2.5 - Improvments and bug fixes to auto macOS edit options
# version 2.6 - Added option to setup fish snippits automatically if fish shell detected on system
# version 2.7 - Improved check mark cross platform compatibility
# version 2.8 - Improved enviroment varable skipping checks to facilitate auto-updates
# version 2.9 - Updates to output from git clone
# version 3.0 - Auto-update script installation included (not active)
# version 3.1 - Improved reliability of update process
# version 2.2 - Minor readme improvements regarding macOS /tmp/ dir edits
# version 2.3 - Added enviroment varable support to setup updates via users crontab
# version 2.4 - Bug fixes
#

# enviroment varibles setup
# set -e SPB_SKIP_OVERWRITE_CHECK "true" ; if you intend to run this script non-interactivly.
# if set to true, then overwiting of existing files will happen without any interactive
# prompt to bottle out ; this may result in data-loss. only intended for use during auto-updates!
if [[ "${SPB_SKIP_OVERWRITE_CHECK}" != "true" ]] ; then
    # SPB_SKIP_OVERWRITE_CHECK enviroment varible not detected ; set to false (default)
    SPB_SKIP_OVERWRITE_CHECK="false"
else
    # if the spb skip is set to true ; then also set the fish function skip overwrite check to true as well
    export SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK="true"
fi

# additional enviroment variables setup
if [[ "${SPB_UPDATE_SCRIPT_SKIP}" != "true" ]] ; then
    # SPB_UPDATE_SCRIPT_SKIP should be set to true, if this script is launced via the update script
    SPB_UPDATE_SCRIPT_SKIP="false"
fi
if [[ "${SPB_CRON_SETUP}" != "true" ]] ; then
    # SPB_CRON_SETUP enviroment varable shoul dbe set to true if you would like to setup an auto update crontab entry
    SPB_CRON_SETUP="false"
fi


# check mark
tick_mark='\xE2\x9C\x94'

which git >> /dev/null ; git_available=${?}
if [[ ${git_available} != 0 ]] ; then
    echo "ERROR! : The git command was not detected on your system."
    echo "         Ensure it is part of your path or install git onto your"
    echo "         system and try running this installer again."
    echo ""
    echo "         Learn more about git the link below :"
    echo "         https://git-scm.com/"
    echo ""
    git # just see if the os reports anything helpful 
    exit -99
fi

# create a build directory, we will be sucking down the latest version of 
# everything from git into this directory, then to clean up, we can delete :)
cd $( mktemp -d /tmp/spb-build.XXXXXXX )
if [[ $? != 0 ]] ; then
        echo "ERROR! : Unable to setup the temporary build dirctory!"
    exit -99 
fi
# double sanity check (not needed) but lets avoid deleting anything important by mistake when we clean up
temporary_build_directory="$(pwd)"
if ! [[ $(echo "$(basename ${temporary_build_directory})" | grep "spb-build") ]] ; then
        echo "ERROR! : Unable to succesfully locate the temporary directory"
    exit -99
fi

# report the temporary build directory : 
echo ""
echo "This script has created a temporay build directory : "
echo "$(pwd)"
echo ""

function elevate_privildges () {
    # if running on macOS this is used to elevate permissions so that 
    # the file /etc/defaults/periodic.conf is able to be modified.
    sudo -k  # force password prompt
}


# clone a copy of the latest version into the temp directory 
echo "Downloading latest version of SPB (start-private-browser)..." 
git clone --progress --depth 1 --single-branch --branch=main https://gist.github.com/henri/34f5452525ddc3727bb66729114ca8b4 start-private-browser-latest  2>&1
if [[ $? != 0 ]] ; then
        echo ""
        echo "ERROR! : Sucking down latest version from git!"
        echo "         It is likely that git is not installed on"
        echo "         this system or there is a problem with"
        echo "         network access or possibly GitHub has"
        echo "         crashed or has been blocked?"
    echo ""
    echo "         I am sure you will sort it out!"
    exit -98
fi

# preform exit if we hit an error ; in addition set an EXIT trap
trap 'echo "" ; echo "Something went horribly wrong! Sorry please try again later." ; echo "" ; rm -f ~/bin/start-private-browser.bash.old.2delete' EXIT
set -e

# enter the local repo
cd start-private-browser-latest
downloaded_version=$(grep -E "^# version " ./050.start-private-browser.bash | tail -n 1 | awk '{print $3}')

# check if there is already a version installed?
spb_upgrade_install="install"
spb_upgrade_install_status="failure"
if [[ -f ~/bin/start-private-browser.bash ]] ; then
    spb_upgrade_install="upgrade"
    echo ""
    echo "////////////////////////////////////////////////////////"
    echo "WARNING! : Looks like you have a copy already installed."
    echo "////////////////////////////////////////////////////////"
    installed_version=$(grep -E "^# version " ~/bin/start-private-browser.bash | tail -n 1 | awk '{print $3}')
    echo ""
    echo "                  Installed version  :  ${installed_version}"
    echo "                 Downloaded version  :  ${downloaded_version}"
    if [[ "${SPB_SKIP_OVERWRITE_CHECK}" != "true" ]] ; then
        echo ""
        echo "                 Existing copy path  :  ~/bin/start-private-browser.bash"
        echo ""
        echo -n "    Should we continue and overwrite the existing copy? [Y/n] : "
        read overwrite_existing
        if \
           [[ "${overwrite_existing}" == "n" ]] || \
           [[ "${overwrite_existing}" == "N" ]] || \
           [[ "${overwrite_existing}" == "no" ]] || \
           [[ "${overwrite_existing}" == "No" ]] || \
           [[ "${overwrite_existing}" == "NO" ]] \
        ; then
           echo ""
           echo "    Understood.. Install aborted. You selected to not overwrite the existing version :"
           echo "                                  ~/bin/start-private-browser.bash"
           echo ""
           # clear EXIT trap and exit (with error) - installation did not complete succesfully. 
           trap - EXIT ; exit -1
        fi
    else
        echo ""
        echo "    WARNING! : Enviroment Varable : SPB_SKIP_OVERWRITE_CHECK = true"
        echo "    WARNING! : Overwriting existing file : ~/bin/start-private-browser.bash"
    fi
    echo ""
else
    echo "Downloaded for installation  :  SPB version  :  ${downloaded_version}"
    echo ""
fi

# *** TODO *** : put in checking version and then just allow upgrades - that could do with some more work sometime

# copy file start-private-browser.bash into place - assumes you have write access to your home directory.
mkdir -p ~/bin/
if [ -e ~/bin/spb-update.bash ] ; then
    # move any old file found to the side for deletion at script run end
    mv ~/bin/start-private-browser.bash ~/bin/start-private-browser.bash.old.2delete
fi
cp 050.start-private-browser.bash ~/bin/start-private-browser.bash
chmod +x ~/bin/start-private-browser.bash
spb_upgrade_install_status="success"
echo "File install location  :  ~/bin/start-private-browser.bash"
echo ""
echo "SPB (Start Private Browser) has been successfully installed!"
echo ""

# copy file spb-update.bash into place - assumes you have write access to your home directory.
mkdir -p ~/bin/
if [ -e ~/bin/spb-update.bash ] ; then
    # move any old file found to the side for deletion at script run end
    mv ~/bin/spb-update.bash ~/bin/spb-update.bash.old.2delete
fi
cp 600.spb-update.bash ~/bin/spb-update.bash
chmod +x ~/bin/spb-update.bash
spb_update_script_status="success"
echo "File install location  :  ~/bin/spb-update.bash"
echo ""
echo "SPB (Start Private Browser) update has been successfully installed!"
echo "You may run this script manually or via a schedular to update SPB."
echo ""

# if SPB_CRON_SETUP enviroment variable is set to ture, then we setup the upate crontab
if [[ "${SPB_CRON_SETUP}" == "true" ]] ; then
    # run the 700.spb-add-to-user-crontab.bash script to setup the crontab
    echo ""
    echo "////////////////////////////////////////////////////////"
    echo "WARNING! : Enviroment Varable : SPB_CRON_SETUP = true"
    echo "////////////////////////////////////////////////////////"
    echo ""
    echo "Attempting to add entry to update SPB into your users crontab..."
    echo ""
    if [ -e ./700.spb-add-to-user-crontab.bash ] ; then
        chmod +x ./700.spb-add-to-user-crontab.bash
        ./700.spb-add-to-user-crontab.bash
    else
        echO ""
        echo "        ERROR! : SPB User crontab setup requested : Unable to locate the spb-add-to-user-crontab.bash script"
        echo ""
        exit -101
    fi
    echo ""
    echo "      SPB crontab entry set succesfully"
    echo ""
    echo "      SPB (Start Private Browser) will attempt to automatically update,"
    echo "      when the system is running and there is an active internet connection."
    echo ""
    echo "      SPB crontab entry may be removed or edited using the command 'crontab -e'"
    echo ""
fi



# prevent exit if we hit an error and remove the EXIT trap
set +e
trap - EXIT

# configure macOS to not auto delete browser data directories from /tmp/
os_type="$(uname)"
if [[ "${os_type}" == "Darwin" ]] && [[ "${SPB_SKIP_OVERWRITE_CHECK}" != "true" ]] ; then 
    mod_applied_to_periodic_conf=$(grep "daily_clean_tmps_ignore" /etc/defaults/periodic.conf | grep "browser-" > /dev/null ; echo ${?})
    if [[ ${mod_applied_to_periodic_conf} != 0 ]] ; then
        # running on macOS
        echo ""
        echo "  SPB specific notes for macOS users :"
        echo ""
        echo "      Some versions of macOS automatically clean-up the /tmp/ directory periodically."
        echo "      In the event your browser becomes unresponsive then this is likely due to such an automatic"
        echo "      clean up of the directory."
        echo ""
        echo "      It is possible to work around this issue by adding an additional line to cleanup script."
        echo "      Making the change to the automated clean up script requires sudo access on the system."
        echo "      The file to modify is prevents automated clean up of the SPB browser data is : " 
        echo "      /etc/defaults/periodic.conf" 
        echo ""
        echo "      Typically, this file contains at least one entry starting with : "
        echo "      daily_clean_tmps_ignore=" 
        echo ""
        echo "      To make the alteration manually edit the file : /etc/defaults/periodic.conf "
        echo "      and locate the last line which states with :"
        echo "      \"daily_clean_tmps_ignore\""
        echo ""
        echo "      Then, directly below that line add the line below :"
        echo "      daily_clean_tmps_ignore=\"\$daily_clean_tmps_ignore browser-\""
        echo ""
        echo "      Once this changes is complete, you should no longer have issues with browser unresponsivness"
        echo "      when the browser is left open for three days or more." 
        echo ""
        echo "      If you plan to only use the browser for less than 72 hours, then this alteration is not needed."
        echo ""
        echo "      It is reccomended that you just let this script to make the above "
        echo "      alteration automatically on your behalf - (this requires sudo access)"
        echo "      Proceed with automatic edits to the file below : "
        echo -n "      '/etc/defaults/periodic.conf' file? [y/N] : "
        read update_peridic_file
        if \
            [[ "${update_peridic_file}" == "y" ]] || \
            [[ "${update_peridic_file}" == "Y" ]]|| \
            [[ "${update_peridic_file}" == "yes" ]] || \
            [[ "${update_peridic_file}" == "Yes" ]] || \
            [[ "${update_peridic_file}" == "YES" ]] \
        ; then
            if ! [ -f /etc/defaults/periodic.conf ] ; then
                echo ""
                echo "        ERROR : Unable to locate /etc/defaults/periodic.conf"
                echo ""
                exit -10
            fi
            grep daily_clean_tmps_ignore /etc/defaults/periodic.conf > /dev/null
            if [[ ${?} != 0  ]] ; then
                echo "" ; echo "        ERROR : origional /tmp/periodic.conf file is missing daily_clean_tmps_ignore variable line(s)" ; echo "" ; exit -8
            fi
            touch /tmp/periodic.conf 
            if [[ ${?} != 0  ]] ; then
                echo "" ; echo "        ERROR : creating tempoary file : /tmp/periodic.conf" ; echo "" ; exit -8
            fi
            chmod 700 /tmp/periodic.conf 
            if [[ ${?} != 0  ]] ; then
                echo "" ; echo "        ERROR : altering file permissions : /tmp/periodic.conf" ; echo "" ; exit -9
            fi
            awk -v n="daily_clean_tmps_ignore=\"\$daily_clean_tmps_ignore browser-\"" '
            /daily_clean_tmps_ignore=/ {l=NR}
            {lines[NR]=$0}
            END {
                for(i=1;i<=NR;i++) {
                print lines[i]
                if(i==l) print n
                }
            }
            ' /etc/defaults/periodic.conf > /tmp/periodic.conf
            if [[ ${?} == 0 ]] ; then
                echo ""
                echo "    In order for this script to automatically modify the /etc/defaults/preidic.conf"
                echo "    file, you will now be prompted for your sudo password."
                echo ""
                elevate_privildges 
                # backup the origional file (just in case)
                sudo cp /etc/defaults/periodic.conf /etc/defaults/periodic.conf.spb.bak
                if [[ ${?} != 0  ]] ; then
                    echo ""
                    echo "        ERROR : unable to create backup of /etc/defaults/periodic.conf"
                    echo "                sudo authentication failed"
                    echo ""
                    exit -10
                fi
                # using tee instead of cat so 
                # that we can use sudo for writing the data
                # + we will easily be able to show file if needed down the road
                sudo tee /etc/defaults/periodic.conf < /tmp/periodic.conf > /dev/null
                if [[ ${?} == 0  ]] ; then
                    rm -rf /tmp/periodic.conf
                    echo ""
                    echo "        Periodic clean script has been successfully updated." 
                    echo "        You are now all set to start use start-private-browser"
                    echo "        with browser sessions which extend beyond a single day."
                    echo ""
                    echo "        A copy of the origional file has been saved : "
                    echo "        /etc/defaults/periodic.conf.spb.bak"
                    echo ""
                    echo "        To restore the origional file, run the command : "
                    echo "        sudo cat /etc/defaults/periodic.conf.spb.bak > /etc/defaults/periodic.conf"
                    echo ""
                else
                   echo ""
                   echo "        ERROR : Unable to update the file : /etc/defaults/periodic.conf"
                   echo "                You could try running the following command manually : " 
                   echo ""
                   echo "                sudo cat /tmp/periodic.conf > /etc/defaults/periodic.conf"
                   echo ""
                fi
            fi
        else 
        echo ""
        echo "  Understood. No changes made to the '/etc/defaults/periodic.conf'" 
        echo ""
    fi
        echo ""
    fi
fi

# show alias commands (various shells) - if we do some shell detection could run this command automatically.
existing_spb_alias_return_code=$( fish -c ' "alias" | grep -E "^alias spb " > /dev/null ; echo $status ' )
if [[ ${existing_spb_alias_return_code} == 0 ]] ; then
    configure_update_spb_fs="update"
else 
    configure_update_spb_fs="configure"
fi
auto_install_fish_snippits_ask="yes"
if $(which fish >/dev/null) ; then
    # if the skipping enviroment varable was set to true, then we will not be asking questions we will just update
    if [[ "${SPB_SKIP_OVERWRITE_CHECK}" == "true" ]] ; then
        auto_install_fish_snippits_ask="no"
        auto_install_fish_snippits="yes"
    fi
    # no existing spb fish alias configured ; so we ask about setting up the fish snippits automatically
    if [[ "${auto_install_fish_snippits_ask}" == "yes" ]] ; then
        echo "Detected fish shell : "
        echo "    You have the fish shell installed, would you like to automatically"
        echo -n "    ${configure_update_spb_fs} the spb (start-private-browser) fish snippits [Y/n] : "
        read auto_install_fish_snippits
        if \
            [[ "${auto_install_fish_snippits}" == "n" ]] || \
            [[ "${auto_install_fish_snippits}" == "N" ]] || \
            [[ "${auto_install_fish_snippits}" == "no" ]] || \
            [[ "${auto_install_fish_snippits}" == "No" ]] || \
            [[ "${auto_install_fish_snippits}" == "NO" ]] \
        ; then
            echo ""
            echo "           Understood.. automated fish spb snippits setup skipped."
            echo ""
        else
           auto_install_fish_snippits="yes"
        fi
    fi
    if [[ "${auto_install_fish_snippits}" == "yes" ]] ; then 
        # kick off the automated fish spb snippits installer
        /bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/henri/4f034f04b35c01e089e98350c902bda8/raw/spb-fish-function-installer.bash)"
        if [[ $? == 0 ]] ; then
            spb_fish_snippits_install_status="success"
        else
            spb_fish_snippits_install_status="failure"
        fi
    fi
fi

command_header_printed="false"
function print_command_header {
    if [[ "${command_header_printed}" == "false" ]] ; then
        echo "  Enter the appriate command for your shell(s) to setup alias"
            echo ""
        command_header_printed="true"
    fi
}

if $(which fish >/dev/null) && [[ ! -e ~/.config/fish/functions/start-private-browser.fish ]] ; then
    print_command_header
    echo "     - fish"
    echo "       alias -s start-private-browser=\"~/bin/start-private-browser.bash\""
    echo ""
fi
if $(which fish >/dev/null) && [[ ! -e ~/.config/fish/functions/spb.fish ]] ; then
    print_command_header
    echo "     - fish"
    echo "       alias -s spb=\"start-private-browser\""
    echo ""
    echo "       If you would like to always have additional parameters passed to start-private-browser command,"
    echo "       then adding them to the alias 'spb' is a good way to always have them present ; especially when"
    echo "       using the supplimentary fish functions found at the link below :"
    echo "       https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8"
    echo ""
fi
if $(which bash >/dev/null) && ! $(grep --silent start-private-browser ~/.bash_alias 2>/dev/null)  ; then
    print_command_header
    echo "     - bash"
    echo "       echo alias start-private-browser=\"~/bin/start-private-browser.bash\" >> ~/.bash_alias && sync && . ~/.bash_alias"
    echo ""
fi
if $(which zsh >/dev/null) && $(ps -a | grep --silent zsh) && ! $(grep --silent start-private-browser ~/.zsh_alias 2>/dev/null)  ; then
    print_command_header
    echo "     - zsh"
    echo "       echo alias start-private-browser=\"~/bin/start-private-browser.bash\" >> ~/.zsh_alias && sync && . ~/.zsh_alias"
    echo ""
fi

# report summarty reagrding installation of spb and snippits 
# this is only displayed if fish snippits optional install was attempted
# the exit values are also pulled for spb update and the fish snippts from this code block
spb_report_summary_header="Installation Summary : "
spb_report_exit_status=0
if [[ "${spb_upgrade_install_status}" == "success" ]] ; then
    spb_report_summary="SPB (Start Private Browser) ${spb_upgrade_install} succesfull  [ ${tick_mark} ] "
else
    spb_report_summary="ERROR! : SPB (Start Private Browser) ${spb_upgrade_install} failed [ X ] "
    spb_report_exit_status=99
fi
if [[ "${spb_fish_snippits_install_status}" == "success" ]] ; then
    echo "" ; echo "${spb_report_summary_header}"
    echo -e "SPB fish snippits ${spb_upgrade_install} completed succesfully [ ${tick_mark} ] "
    echo -e "${spb_report_summary}"
elif [[ "${spb_fish_snippits_install_status}" == "failure" ]] ; then 
    echo "" ; echo "${spb_report_summary_header}"
    echo -e "ERROR! : SPB fish snippits ${spb_upgrade_install} failed [ X ]"
    echo -e "${spb_report_summary}"
    spb_report_exit_status=98
fi
echo ""


# clean up
cd /tmp/ && rm -rf ${temporary_build_directory}
spb_clean_up_exit_status=${?}

# setup traps for exit and cleanup with command to remove old scripts and support files ; idea is to keep any old inodes around as long as possible
if [[ "${SPB_UPDATE_SCRIPT_SKIP}" != "true" ]] ; then
    trap 'rm -f ~/bin/start-private-browser.bash.old.2delete ; rm -f ~/bin/spb-update.bash.old.2delete' EXIT
else
    trap 'rm -f ~/bin/start-private-browser.bash.old.2delete' EXIT
fi

# confirm we exit with correct overall status from all operations
if [[ ${spb_clean_up_exit_status} == 0 ]] && [[ ${spb_report_exit_status} == 0 ]] ; then
    exit 0
else
    exit 1
fi

