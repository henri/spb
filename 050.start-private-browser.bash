#!/usr/bin/env bash
#
# Start many instances of Brave at the same time all within the same linux graphical login
# The general idea behind this script to start a private instance of brave-browser
# with local user data directory set to a directory within /tmp/ (by default)
#
# This also allows you to easily run multiple instances of the browser all with different
# startup options.
#
# This script may be easily modified to work with different Blink based browsers for example
# chromium, vivaldi, opera etc...
#
# (C) Copyright Henri Shustak 2024
#
# Released under the GNU GPLv3 or later license :
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Project home page (featuring additional information and easy installation guide) :
# https://github.com/henri/spb
#
# version 1.0 - initial release
# version 1.1 - added a check to make sure brave is installed before doing anything
# version 1.2 - added a basic help menu explaining the functionality (if you call it with -h or --help)
# version 1.3 - added basic support for FreeBSD and MacOS
# version 1.4 - added support for listing the running sessions (just list them via screen - nothing internal keeping track)
# version 1.5 - initial support for passing additional options to brave implemented (note : zero checking of option validity)
# version 1.6 - updates to the help output\
# version 1.7 - added url to download brave if it is not installed
# version 1.8 - added user-agent usage example
# version 1.9 - added additional sanity check
# version 2.0 - additional requirement check that screen is installed before doing anything
# version 2.1 - bug fix related to screen detection
# version 2.2 - minor improvement when listing active sessions
# version 2.3 - added additional usage notes
# version 2.4 - added improved support for displaying help
# version 2.5 - improved option parsing system
# version 2.6 - initial foundations for templating sub-system implemented
# version 2.7 - improved option parsing to allow for greater flexibility
# version 2.8 - increased verbosity of output while loading template data
# version 2.9 - added locking to the templates and squashed bugs
# version 3.0 - added standard option to not start incognito mode
# version 3.1 - added a quite mode option for less verbose output
# version 3.2 - prevent copying a template while it is being edited
# version 3.3 - improved template lock file session support, improved template support and squashed bugs
# version 3.4 - reporting and error handling relating to lock files improved
# version 3.5 - further improvements to template lock file subsystem reliability and user support dialog
# version 3.6 - cross platform compatibility enhancement
# version 3.7 - added a force stop command (to kill an spb session)
# version 3.8 - foundation laid for the template system to support browser compatibility
# version 3.9 - further improvements to multi-browser support within the templating system
# version 4.0 - added update option support
# version 4.1 - minor improvements to output relating to updates
# version 4.2 - bug fixes
# version 4.3 - altered configuration defaults working towards improved browser compatibility
# version 4.4 - prepared multi-browser compatibility foundations
# version 4.5 - initial templating compatibility checks implemented
# version 4.6 - improved template listing output in relation to multi-browser improvements
# version 4.7 - bug fixes relating to older versions of bash
# version 4.8 - improvements to mutli-browser compatibility
# version 4.9 - initial environment variable support for spb browser configuration
# version 5.0 - initial spb configuration file support - only via sourcing
# version 5.1 - bug fixes relating to loading order of configuration file
# version 5.2 - improved template listing output and bug fixes relating to multi-browser support
# version 5.2 - improvements with regards support for cross-platform multi-browser support
# version 5.3 - updates to the built in help
# version 5.4 - bug fixes
# version 5.5 - added ability to list available browsers in multi-mode with option --list-browsers
# version 5.6 - improved multi-browser support
# version 5.7 - bug fix related to loading templates
# version 5.8 - improved logic paths during edge cases of browser template laoding
# version 5.9 - implemented detection for shells without connected display enviroment(s)
# version 6.0 - experimental support for ungoogled-chrome, firefox and palemoon
# version 6.1 - improved template loading, additional linux distribution support (this needs some work)
# version 6.2 - improved argument parsing and bug fixes
# version 6.3 - bug fix relating to experimental firefox and palemoon support
# version 6.4 - added template copy progress bar using gcp if it is installed on the system
# version 6.5 - added template copy progress bar using pv and tar if they are available on the system and gcp is not available
# version 6.6 - bug fix resolved relating to du options on macOS and also added APFS template cloning support (it is faster)
# version 6.7 - bug fix we now correctly report when we are copying or cloning template data
# version 6.8 - standard mode reporting improvements
# version 6.9 - added support for custom spb-template path override via the option --template-path
# version 7.0 - experimental support for opera
# version 7.1 - initial support for verbose option currently providing reporting of the path to to user data for session
# version 7.2 - bug fix relating to following template symlinks when using the --list-templates option
# version 7.3 - added option to overide the default /tmp/ directory used for storing temporary browser data via spb.config file
# version 7.4 - very experimental support for zen browser
# version 7.5 - updates to the help
# version 7.6 - enabled post-browser script launching subsystem
# version 7.7 - exerimental support for omarchy
# version 7.8 - added --browser-path option to allow the path to be set via the CLI rather than just via an envioment variable
# version 7.9 - improved --list-browser option output to check if a browser is installed on the system
# version 8.0 - slightly improved help message when listing templates with the --list-templates option
# version 8.1 - added experimental support for cachyos
# version 8.2 - added option to allow for editing of the active spb configuration file using the --edit-configuration option
# version 8.3 - improved template listing display for browsers with longer names (specifically chromium)
# version 8.4 - improved verbose output when listing templates to include template directory


##
## Configuration of Variables
## 

# configuration variables
screen_session_prefix="spb-session"                 #  prefix of the screen session name
spb_temp_data_path="/tmp"                           #  temporary data storage path
temp_dir_name_prefix="spb-browser"                  #  prefix for spb temporary instance data storage
template_dir_base="~/bin/spb-templates"             #  location of spb templates
template_browser_id_filename="spb-browser.id"       #  file which will contain the browser identifier for this template
update_script_path="~/bin/spb-update.bash"          #  where to find the spb-update script
update_script_arguments="--auto-monitoring"         #  arguments passed to update script when running an update
spb_configuration_file_name="spb.config"            #  default config file name

# lock file variables to protect templates being edited
spb_template_lock_file_name="spb-template-edit.lock"
spb_etlfr_cmd="" # spb edit template lock file remove command (leave this blank it is automatically updated when required)

# post browser launch subsystem variables
post_browser_cmd="" # executed once the browse has been launched (leave this blank it is automatically updated when required)

# setup variables for processing arguments we ares specifically NOT using get opts 
args=("$@")
index=0
pre_index=0
super_pre_index=0
num_args=$#
skip_arg="false"
pre_skip_arg="false"
super_pre_skip_arg="false"
pre_arg_scan_proceed="true"
dot_dot_dot=""


template_dir_base_default_override=""
spb_default_multi_browser_support="false"
spb_browser_path_externally_configured="false"

# os detection
os_type=$(uname -s | tr '[:upper:]' '[:lower:]')

# default multi-browser support enabled - if we are running bash version 4 or later
if [[ ! -z ${BASH_VERSINFO} ]] ; then
    if [[ ${BASH_VERSINFO} -ge 4 ]] ; then
        # default browser values - these are the commands which we run on various operating systems for various browsers
        # remember if your operating system is not listed, it is possible to use environment variables or the configuration
        # file to specify the browser name and browser path for any browser / operating system pair
        declare -A spb_default_browser_data
        # # # # # # # # # # # # #
        spb_default_browser_data["zen:linux:mint"]="zen"
        spb_default_browser_data["zen:linux:arch"]="zen"
        spb_default_browser_data["zen:linux:omarchy"]="zen"
        spb_default_browser_data["zen:linux:ubuntu"]="zen"
        spb_default_browser_data["zen:linux:debian"]="zen"
        spb_default_browser_data["zen:linux:endeavouros"]="zen"
        spb_default_browser_data["zen:linux:manjaro"]="zen"
        spb_default_browser_data["zen:linux:centos"]="zen"
        spb_default_browser_data["zen:linux:fredora"]="zen"
        spb_default_browser_data["zen:linux:cachyos"]="zen"
        spb_default_browser_data["zen:freebsd"]="zen"
        spb_default_browser_data["zen:darwin"]="/Applications/Zen.app/Contents/MacOS/zen"
        # # # # # # # # # # # # #
        spb_default_browser_data["opera:linux:mint"]="opera"
        spb_default_browser_data["opera:linux:arch"]="opera"
        spb_default_browser_data["opera:linux:omarchy"]="opera"
        spb_default_browser_data["opera:linux:ubuntu"]="opera"
        spb_default_browser_data["opera:linux:debian"]="opera"
        spb_default_browser_data["opera:linux:endeavouros"]="opera"
        spb_default_browser_data["opera:linux:manjaro"]="opera"
        spb_default_browser_data["opera:linux:centos"]="opera"
        spb_default_browser_data["opera:linux:fredora"]="opera"
        spb_default_browser_data["opera:linux:cachyos"]="opera"
        spb_default_browser_data["opera:freebsd"]="opera"
        spb_default_browser_data["opera:darwin"]="/Applications/Opera.app/Contents/MacOS/Opera"
        # # # # # # # # # # # # #
        spb_default_browser_data["palemoon:linux:mint"]="palemoon"
        spb_default_browser_data["palemoon:linux:arch"]="palemoon"
        spb_default_browser_data["palemoon:linux:omarchy"]="palemoon"
        spb_default_browser_data["palemoon:linux:ubuntu"]="palemoon"
        spb_default_browser_data["palemoon:linux:debian"]="palemoon"
        spb_default_browser_data["palemoon:linux:endeavouros"]="palemoon"
        spb_default_browser_data["palemoon:linux:manjaro"]="palemoon"
        spb_default_browser_data["palemoon:linux:centos"]="palemoon"
        spb_default_browser_data["palemoon:linux:fredora"]="palemoon"
        spb_default_browser_data["palemoon:linux:cachyos"]="palemoon"
        spb_default_browser_data["palemoon:freebsd"]="palemoon"
        spb_default_browser_data["palemoon:darwin"]="/Applications/Pale Moon.app/Contents/MacOS/palemoon"
        # # # # # # # # # # # # #
        spb_default_browser_data["firefox:linux:mint"]="firefox"
        spb_default_browser_data["firefox:linux:arch"]="firefox"
        spb_default_browser_data["firefox:linux:omarchy"]="firefox"
        spb_default_browser_data["firefox:linux:ubuntu"]="firefox"
        spb_default_browser_data["firefox:linux:debian"]="firefox"
        spb_default_browser_data["firefox:linux:endeavouros"]="firefox"
        spb_default_browser_data["firefox:linux:manjaro"]="firefox"
        spb_default_browser_data["firefox:linux:centos"]="firefox"
        spb_default_browser_data["firefox:linux:fredora"]="firefox"
        spb_default_browser_data["firefox:linux:cachyos"]="firefox"
        spb_default_browser_data["firefox:freebsd"]="firefox"
        spb_default_browser_data["firefox:darwin"]="/Applications/Firefox.app/Contents/MacOS/Firefox"
        # # # # # # # # # # # # #
        spb_default_browser_data["ungoogled-chromium:linux:mint"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:linux:ubuntu"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:linux:debian"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:linux:arch"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:linux:omarchy"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:linux:endeavouros"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:linux:manjaro"]="ungoogled-chrome"
        spb_default_browser_data["ungoogled-chromium:linux:centos"]="ungoogled-chrome"
        spb_default_browser_data["ungoogled-chromium:linux:fredora"]="ungoogled-chrome"
        spb_default_browser_data["ungoogled-chromium:linux:cachyos"]="ungoogled-chrome"
        spb_default_browser_data["ungoogled-chromium:freebsd"]="ungoogled-chromium"
        spb_default_browser_data["ungoogled-chromium:darwin"]="/Applications/Chromium.app/Contents/MacOS/Chromium"
        # # # # # # # # # # # # #
        spb_default_browser_data["vivaldi:linux:mint"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:ubuntu"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:debian"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:arch"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:omarchy"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:endeavouros"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:manjaro"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:centos"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:fredora"]="vivaldi"
        spb_default_browser_data["vivaldi:linux:cachyos"]="vivaldi"
        spb_default_browser_data["vivaldi:freebsd"]="vivaldi"
        spb_default_browser_data["vivaldi:darwin"]="/Applications/Vivaldi.app/Contents/MacOS/Vivaldi"
        # # # # # # # # # # # # #
        spb_default_browser_data["brave:linux:mint"]="brave-browser"
        spb_default_browser_data["brave:linux:ubuntu"]="brave-browser"
        spb_default_browser_data["brave:linux:debian"]="brave-browser"
        spb_default_browser_data["brave:linux:arch"]="brave"
        spb_default_browser_data["brave:linux:omarchy"]="brave"
        spb_default_browser_data["brave:linux:endeavouros"]="brave"
        spb_default_browser_data["brave:linux:manjaro"]="brave"
        spb_default_browser_data["brave:linux:centos"]="brave-browser"
        spb_default_browser_data["brave:linux:fredora"]="brave-browser"
        spb_default_browser_data["brave:linux:cachyos"]="brave"
        spb_default_browser_data["brave:freebsd"]="brave-browser"
        spb_default_browser_data["brave:darwin"]="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
        # # # # # # # # # # # # #
        spb_default_browser_data["chromium:linux:mint"]="chromium"
        spb_default_browser_data["chromium:linux:ubuntu"]="chromium"
        spb_default_browser_data["chromium:linux:debian"]="chromium"
        spb_default_browser_data["chromium:linux:arch"]="chromium"
        spb_default_browser_data["chromium:linux:omarchy"]="chromium"
        spb_default_browser_data["chromium:linux:endeavouros"]="chromium"
        spb_default_browser_data["chromium:linux:manjaro"]="chromium"
        spb_default_browser_data["chromium:linux:centos"]="chromium"
        spb_default_browser_data["chromium:linux:fredora"]="chromium"
        spb_default_browser_data["chromium:linux:cachyos"]="chromium"
        spb_default_browser_data["chromium:freebsd"]="chromium"
        spb_default_browser_data["chromium:darwin"]="/Applications/Chromium.app/Contents/MacOS/Chromium"
        # # # # # # # # # # # # #
        spb_default_multi_browser_support="true"
        # # # # # # # # # # # # #
    fi
fi

# super-pre argument scanning (special arguments for overiding settings) - yes we custom argument parsing in 2025
for arg in "$@" ; do

    # skip some parameters passed into script
    if [[ "${super_pre_skip_arg}" == "true" ]] ; then
        super_pre_skip_arg="false"
        ((super_pre_index++))
    continue
    fi

    # skip some parameters passed into script
    if [[ "${super_pre_skip_arg}" == "true" ]] ; then
        super_pre_skip_arg="false"
        ((super_pre_index++))
    continue
    fi

    # look ahead for passed argument parameters
    if (( super_pre_index + 1 < num_args )) ; then
        next_arg="${args[super_pre_index + 1]}"
    else
        next_arg=""
    fi

    # check for template or template editing
    if [[ "${arg}" == "--template-path" ]] ; then
        # check they are not listed more than once
        if [[ "${template_dir_base_default_override}" != "" ]] ; then
            echo ""
            echo "ERROR! : Using the ${arg} option is only allowed once"
            echo ""
            exit -75
        fi
        if [[ "${next_arg}" != "" ]] ; then
            # configure the system to skip the next argument for processing 
            # as it is the value for this one
            super_pre_skip_arg="true"
            valid_argument_found="true"
            template_dir_base_default_override="${next_arg}"
            template_dir_base="${template_dir_base_default_override}"
        else
            echo ""
            echo "ERROR! : Using the ${arg} option requires specifying a valid spb-template path."
            echo "         the spb-template directrory path by default is set to the following : "
            echo ""
            echo "             ${template_dir_base}"
            echo ""
            echo "         The template directory contains all the other templates not a single"
            echo "         template."
            exit -77
        fi
    fi

    # check for edit configuration option
    if [[ "${arg}" == "--edit-configuration" ]] ; then
        edit_configuration_file_requested="true"
        valid_argument_found="true"
    fi

    # check if quite mode should be enabled
    if [[ "${arg}" == "--quite" ]] ; then
        quite_mode="true"
        valid_argument_found="true"
    fi

    # check to see if browser path specified as argument
    if [[ "${arg}" == "--browser-path" ]] ; then

        # check they are not listed more than once
        if [[ "${spb_browser_path_externally_configured}" == "true" ]] ; then
            echo ""
            echo "ERROR! : Using the ${arg} option is only allowed once"
            echo ""
            exit -75
        fi

        # look ahead for passed argument parameters
        if (( super_pre_index + 1 < num_args )) ; then
            super_pre_next_arg="${args[super_pre_index + 1]}"
        else
            super_pre_next_arg=""
        fi

        # okay lets see whats what
        if [[ "${super_pre_next_arg}" != "" ]] ; then
            # configure the system to skip the next argument for processing 
            # as it is the value for this one
            super_pre_skip_arg="true"
        else
            echo ""
            echo "ERROR! : When you specify --browser-path you must also"
            echo "         supply a browser path which will be used"
            echo "         instead of the default browser path."
            echo ""
            exit -164
        fi

        # update the browser path and other variables which depend on the browser path 
        spb_browser_path="${super_pre_next_arg}"
        spb_browser_path_externally_configured="true"
    
    fi

    ((super_pre_index++))

done


# configure the default SPB browser name
spb_browser_name_default="brave"
spb_browser_name_externally_configured="false"
spb_browser_is_default="true"
if [[ -z "$spb_browser_name" ]] ; then
    # check this value has not been configured via configuration file / environment variables
    if [[ "${os_type}" == "darwin" ]] ; then 
        if [[ "${spb_browser_name}" == "ungoogled-chromium" ]] && [[ -d /Applications/Chromium.app ]] ; then
            # check if ungoogled-chromium is installed (on macOS) - the install will share the same location and name so this is somewhat important
            chromium_developer=$(spctl -a -vvv -t install /Applications/Chromium.app 2>&1 | grep "origin=Developer ID Application" | awk -F "origin=Developer ID Application: " '{print $2}')
            if [[ "${chromium_developer}" != "Qian Qian (B9A88FL5XJ)" ]] ; then
                echo "ERROR! : You have requested the browser : ${spb_browser_name}"
                echo "         However, ungoogled-chromium is not installed on your system."
                exit -34
            fi
        fi
        if [[ "${spb_browser_name}" == "chromium" ]] && [[ -d /Applications/Chromium.app ]] ; then
            # check if chromium is installed
            chromium_developer=$(spctl -a -vvv -t install /Applications/Chromium.app 2>&1 | grep "origin=Developer ID Application" | awk -F "origin=Developer ID Application: " '{print $2}')
            if [[ "${chromium_developer}" == "Qian Qian (B9A88FL5XJ)" ]] ; then
                echo "WARNING! : You have requested the browser : ${spb_browser_name}"
                echo "           However, ungoogled-chromium is installed on your system."
            fi
        fi
    fi
    spb_browser_name="${spb_browser_name_default}"
else
    # this value has been configured via configuration file / environment variable
    spb_browser_name_externally_configured="true"
fi
if [[ "${spb_browser_name_default}" != "${spb_browser_name}" ]] ; then
    # this variable is used to keep track of which variables need to have been set
    # sanity checks in relation to templating subsystem 
    # it is important to ensure the template type 
    # matches the specified browser
    spb_browser_is_default="false"
fi

spb_external_count=0
[[ ! -z "${spb_browser_path}" ]] && spb_external_count=$((spb_external_count+1))
[[ "${spb_browser_name_externally_configured}" == "true" ]] && spb_external_count=$((spb_external_count+1))
if [[ spb_external_count -eq 1 ]] ; then
    if [[ "${spb_browser_name_externally_configured}" == "false" ]] || [[ "${spb_default_multi_browser_support}" == "false" ]]  ; then
        if [[ "${spb_browser_path_externally_configured}" == "false" ]] ; then
            echo "" ; echo "ERROR! : Unable to proceed environment variable problem!" ; echo ""
            if [[ "${spb_default_multi_browser_support}" == "true" ]]  ; then
                # multi-broser support enabled - report the situation relating to environment variables
                echo "         When the 'spb_browser_path' enviroment varable is configured,"
                echo "         the 'spb_browser_name' varable must also be set!"
            else
                # multi-browser support not enabled - explain one of these has been set but not both of them 
                echo "         Automatic multi-browser support is unavailable due to the older version of BASH!"
                echo "         Upgrade BASH or when configure either of the following environment variables :"
                echo ""
                echo "                         spb_browser_name or spb_browser_path"
                echo ""
                echo "         You must also configure the other. They either must both be set or alternatively"
                echo "         neither variable should be externally configured."

            fi
            echo ""
            echo "         This requirement is in relation to the template"
            echo "         system directory organization."
            echo ""
            exit -176
        fi
    fi
fi





# List of currently supported configuration file options
# set these as exported environment variables or place them
# in the configuration file and they will automatically be
# exported when this script runs and finds the configuration
# file. Configuration file path is within the variable :
# spb_configuration_file_name (above in this script)
#
# export spb_browser_name="brave"
# export spb_browser_path="brave-browser"
# export spb_temp_data_path="/tmp"
#

# configure the configuration file paths
spb_configuration_file_path="${template_dir_base}/${spb_configuration_file_name}" # using the template directory to store the configuration file (TODO : needs to be altered to allow changing location of the template directory more easily)
spb_configuration_file_absolute="${spb_configuration_file_path/#\~/$HOME}" # expand the home tild if needed

# edit configuration file (--edit-configuration)
if [[ "${edit_configuration_file_requested}" == "true" ]] ; then
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "Editing SPB Configuration File : ${spb_configuration_file_absolute}"
    fi
    ${VISUAL:-${EDITOR:-nano}} ${spb_configuration_file_absolute}
    exit ${?}
fi

# configuration file loading
if [ -r ${spb_configuration_file_absolute} ] ; then
    # lets start with sourcing, then we can move onto parsing
    source ${spb_configuration_file_absolute}
fi

# update the template directory parent so that it is browser specific
template_dir_parent="${template_dir_base}/${spb_browser_name}"     

# set the temp_path now we have sourced the configuration file
temp_path="${spb_temp_data_path%/}/${temp_dir_name_prefix}"  



# updated variables and the defaults
creating_new_template="false"
spb_list_templates="false"

new_template_dir_name=""
edit_template_dir_name=""
use_template_dir_name=""
use_template_dir_absolute=""
template_show_progress_bar="true" # even this is set to true, the size of the template must be exceed the value set in template template_size_to_show_progress_bar before the progress bar is shown
template_size_to_show_progress_bar="180" # mesured in MB (if the tempalte is greater than this size and gcp is installed, then a progress bar is displayed during the copy)
help_wanted="no"
update_wanted="no"
valid_argument_found="false"
standard_mode="false" # when set to true, we will not default to running incognito window
verbose_mode="false" # when set to true additional information reported to standard out
quite_mode="false"
force_stop_mode="false"
edit_configuration_file_requested="false"
template_browser_id_absolute="" # when creating a new template this is set to the full absolute path to the template browser_id file

# check mark
tick_mark='\xE2\x9C\x94'



##
## Argument Processing
## 


# pre argument scanning (arguments which will almost always end up exiting before we actually start a browser)
for arg in "$@" ; do

  # skip some parameters passed into script
  if [[ "${pre_skip_arg}" == "true" ]] ; then
    pre_skip_arg="false"
    ((pre_index++))
    continue
  fi

  # check for help wanted
  if [[ "${arg}" == "-h" ]] || [[ "${arg}" == "--help" ]] ; then
    help_wanted="yes"
    valid_argument_found="true"
    break
  fi

  # list browsers
  if [[ "${arg}" == "--list-browsers" ]] ; then
    if [[ "${spb_default_multi_browser_support}" == "false" ]] ; then
        echo ""
        echo "ERROR! : You have requested a list of browsers."
        echo "         Unfortunately multi-browser support is"
        echo "         not available due to your older version"
        echo "         of bash on this system. Upgrade BASH"
        echo "         and try again."
        echo ""
        exit -150
    fi
    # build unique list of browsers
    for key in "${!spb_default_browser_data[@]}"; do
        if [[ $( echo "${key}" | awk -F ":" '{print $2}' | grep "${os_type}" ) ]] ; then
            spb_default_browser_list="${key%%:*}\n${spb_default_browser_list}"
        fi
    done
    browser_list_unique=$(echo -e ${spb_default_browser_list} | awk 'NF' | sort -u)
    # carry out some os detection checks and set defaults if running unsupported operating system
    if [[ "${os_type}" == "linux" ]] ; then
        distro=$(grep ^ID= /etc/os-release | awk -F "=" '{print $2}' )
        if [[ "${distro}" == "linuxmint" ]] ; then distro="mint" ; fi
        spb_browser_path="${spb_default_browser_data[brave:$os_type:$distro]}"
    else
        spb_browser_path="${spb_default_browser_data[brave:$os_type]}"
    fi
    if [[ "${spb_browser_path}" == "" ]] ; then
        echo ""
        echo " WARNING!  :  You have requested a list of browsers."
        echo "              Unfortunately your operating system is"
        echo "              not yet offically supported by SPB."
        echo ""
        echo "              The information displayed below may"
        echo "              include inaccuracies."
        echo ""
        os_type="linux" # we make a guess and go with linux.
        distro="mint" # we make a guess and go with mint.
    fi
    echo ""
    echo " installed    name-of-browser"
    echo ""
    # list browsers and their installation status (indicated with a tick)
    for spb_browser_name in $browser_list_unique ; do
        installed=" "
        if [[ "${os_type}" == "linux" ]] ; then
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type:$distro]}"
        else
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type]}"
        fi
        # check if browser is installed and found in path
        which $spb_browser_path 2>/dev/null >/dev/null ; if [[ ${?} == 0 ]] ; then installed="${tick_mark}" ; fi
        echo -e "     ${installed}        ${spb_browser_name}"
    done
    echo ""
    exit 0
  fi

  # check for update wanted
  if [[ "${arg}" == "--update" ]] ; then
    update_wanted="yes"
    valid_argument_found="true"
    break
  fi

  # check for listing sessions (if found we will exit)
  if [[ "${arg}" == "-ls" ]] || [[ "${arg}" == "-l" ]] || [[ "${arg}" == "--list" ]]; then
    output_list=$(screen -ls | grep .${screen_session_prefix}- | awk '{print $1}' | sort -n)
    if [[ "${output_list}" != "" ]] ; then
        # output_list is not empty - list the items
        echo "${output_list}"
        exit 0
    else
        echo "SPB (start-private-browser) session was not detected."
        exit -88
    fi
  fi

  # list templates
  if [[ "${arg}" == "--list-templates" ]] ; then
    spb_list_templates="true"
  fi
  
  # forcefully close a browser session via identifier
  if [[ "${arg}" == "--force-stop" ]] ; then
    force_stop_mode="true"
  fi

  # check if verbose mode should be enabled
  if [[ "${arg}" == "--verbose" ]] ; then
    verbose_mode="true"
    valid_argument_found="true"
  fi

  # check to see if browser mode should be enabled
  if [[ "${arg}" == "--browser" ]] ; then

    # check they are not listed more than once
    if [[ "${spb_browser_name_externally_configured}" == "true" ]] ; then
        echo ""
        echo "ERROR! : Using the ${arg} option is only allowed once"
        echo ""
        exit -75
    fi

    # look ahead for passed argument parameters
    if (( pre_index + 1 < num_args )) ; then
        pre_next_arg="${args[pre_index + 1]}"
    else
        pre_next_arg=""
    fi

    if [[ "${spb_default_multi_browser_support}" == "false" ]] && [[ "${spb_browser_path_externally_configured}" == "false" ]] ; then
        echo ""
        echo "ERROR! : SPB multi-browser Support is not available!"
        echo ""
        echo "         This is due to you running an older version"
        echo "         of BASH on your system, please update to"
        echo "         latest version of BASH if you would like"
        echo "         to use the --browser option."
        echo ""
        echo "         If you want to use an alternative browser"
        echo "         but do not want to upgrade your version"
        echo "         of BASH, then you may configure the alt"
        echo "         browser by setting environment variables."
        echo "         It is possible to set these in the SPB"
        echo "         configuration file or via your shell."
        echo ""
        echo "         Finally, it is also possible to use the "
        echo "         --browser-path option to specify a path"
        echo "         for your browser."
        echo ""
        echo "         For addiitonal help use the command : "
        echo "         ${0} --help"
        echo ""
        exit -165
    fi

    # okay lets see whats what
    if [[ "${pre_next_arg}" != "" ]] ; then
        # configure the system to skip the next argument for processing 
        # as it is the value for this one
            pre_skip_arg="true"
    else
        echo ""
        echo "ERROR! : When you specify --browser you must also"
        echo "         supply a browser name which will be used"
        echo "         instead of the default browser name."
        echo ""
        exit -164
    fi

    # update the browser name and other variables which depend on the browser name 
    spb_browser_name="${pre_next_arg}"
    spb_browser_name_externally_configured="true"
    if [[ "${spb_browser_name_default}" != "${spb_browser_name}" ]] ; then 
        spb_browser_is_default="false" 
    fi
    template_dir_parent="${template_dir_base}/${spb_browser_name}"
    
  fi

  ((pre_index++))

done


# ensure that if the browser path is configud via an option that the browser name is also configured
if [[ "${spb_browser_path_externally_configured}" == "true" ]] && [[ "${spb_browser_name_externally_configured}" != "true" ]] ; then
    echo ""
    echo "ERROR! : Using the --browser-path option also requires using the --browser option."
    echo ""
    echo "         When the 'spb_browser_path' enviroment varable is configured,"
    echo "         the 'spb_browser_name' varable must also be set!"
    echo ""
    exit -99
fi


# show usage information
if [[ "${help_wanted}" == "yes" ]] ; then
    echo ""
    echo "         SPB or 'start-private-browser' is a wrapper to the brave-browser command."
    echo ""
    echo "         This wrapper allows you to quickly start as many separate instances"
    echo "         of the brave-browser as your system has available memory to run"
    echo "         simultaneously under a single graphical login."
    echo ""
    echo "         Requirements include gnu/screen and the brave-browser to be installed"
    echo "         on your system. This script has been mildly tested on GNU/LINUX Mint."
    echo "         It is possible this will also work on many other POSIX compliant"
    echo "         operating systems. Your millage may vary."
    echo ""
    echo ""
    echo ""
    echo "         Usage Summary : "
    echo ""
    echo "            # open a new private browser instance - optionally pass in a URL"
    echo "            $ start-private-browser [URL-TO-OPEN]"
    echo ""
    echo "            # show list of private browser instances"
    echo "            $ start-private-browser --list"
    echo ""
    echo "            # start the browser but no incognito option will be passed to the browser"
    echo "            $ start-private-browser --standard [URL-TO-OPEN]"
    echo ""
    echo "            # suppress important notification output"
    echo "            $ start-private-browser --quite"
    echo ""
    echo "            # additional information output"
    echo "            $ start-private-browser --verbose"
    echo ""
    echo "            # force-ably close a browser session if it has hung"
    echo "            $ start-private-browser --force-stop <instance-identifier>"
    echo ""
    echo "            # update the spb system and associated fish snippets using default options"
    echo "            $ start-private-browser --update"
    echo ""
    echo ""
    echo "         Multi-Browser Suppport : "
    echo ""
    echo "            # specify a browser name which will be loaded rather than the default"
    echo "            $ start-private-browser --browser <name-of-browser>"
    echo ""
    echo "            # show list of default browser names which may be selected"
    echo "            $ start-private-browser --list-browsers"
    echo ""
    echo "            # specify a browser path to use rather than the default"
    echo "            $ start-private-browser --browser-path <path-to-browser>"
    echo ""
    echo ""
    echo "         Templates (Usage & Management) : "
    echo ""
    echo "             # create a new template"
    echo "             $ start-private-browser --new-template <template-name>"
    echo ""
    echo "             # list available templates"
    echo "             # start-private-browser --list-templates"
    echo ""
    echo "             # edit an existing template"
    echo "             $ start-private-browser --edit-template <template-name>"
    echo ""
    echo "             # load an existing template"
    echo "             $ start-private-browser --template <template-name>"
    echo ""
    echo "             # override the default spb-tamplates path : ~/bin/spb-templates"
    echo "             #"
    echo "             #    use the '--template-path' overide option with caution"
    echo "             #    carfully read the note below to understand implications"
    echo "             #"
    echo "             #    note : the --template-path is ***NOT*** used for setting the use of a specific template,"
    echo "             #           rather it is the directory which holds all templates for all browsers and which"
    echo "             #           also stores the spb configuration file. The '${spb_configuration_file_name}' contains"
    echo "             #           various start-private-browser options. If you modify the configuration file, then using"
    echo "             #           the --template-path option to select a custom path will result in those options"
    echo "             #           not being detected (unless you copy/link settings to your specified path)"
    echo "             #"
    echo "             $ start-private-browser --template-path <template-path>"
    echo ""
    echo ""
    echo "         Configuration File : "
    echo ""
    echo "             # SPB supports settings being stored within a configuration file. By creating "
    echo "             # a configuraton file it is possible to update and/or overwrite SPB defaults."
    echo ""
    echo "             Based on current SPB settings if a configuration file is found, then it will be "
    echo "             sourced from the following path :"
    echo ""
    echo "             ${spb_configuration_file_path}"
    echo ""
    echo "             # A full list of configuration file options which are able to be overidden is visiable by"
    echo "             # inspecting the SPB soruce code. Example configuration files are avilable via"
    echo "             # the project home page."
    echo ""
    echo "             # It is possible to have multiple SPB configuration files and template sets on your system"
    echo "             # and switch between them using the SPB \"--template-path\" option (see previous section)."
    echo ""
    echo "             # Edit the active configuration file (using VISUAL and then EDITOR enviroment varables)"
    echo "             $ start-private-browser --edit-configuration"
    echo ""
    echo ""
    echo "         Additional Resources : "
    echo ""
    echo "            # additional argument information is viewable via the brave-browser man page : "
    echo "            $ man brave-browser"
    echo ""
    echo "            # list of additional command line arguments : "
    echo "            https://support.brave.com/hc/en-us/articles/360044860011-How-Do-I-Use-Command-Line-Flags-in-Brave"
    echo ""
    echo ""
    echo "         Example Usage: "
    echo ""
    echo "            # simply start a new private browser"
    echo "            $ start-private-browser "
    echo ""
    echo "            # the same as above but open the browser page on the passed in URL"
    echo "            $ start-private-browser \"https://brave.com\""
    echo ""
    echo "            # start a new private browser session using the tor network"
    echo "            $ start-private-browser --tor"
    echo ""
    echo "            # start a new private browser session using vivaldi as the browser"
    echo "            $ start-private-browser --browser vivaldi"
    echo ""
    echo "            # pass additional argument (proxy in this example) to private browser"
    echo "            $ start-private-browser --proxy-server=\"http://myproxy.com:9090\" \"https://brave.com\""
    echo ""
    echo "            # pass additional argument (app mode [eg no toolbars] in this example) to private browser"
    echo "            $ start-private-browser --app=\"https://brave.com\""
    echo ""
    echo "            # start up private browser with multiple URLs"
    echo "            $ start-private-browser duckduckgo.com wolframalpha.com kagi.com"
    echo ""
    echo "            # start browser with specific window position and open xkcd.com"
    echo "            $ start-private-browser --window-position=10,10 xkcd.com"
    echo ""
    echo "            # start browser with specific window size and open thefarside.com"
    echo "            $ start-private-browser --window-size=500,900 thefarside.com"
    echo ""
    echo "            # start browser with larger / smaller user interface elements"
    echo "            $ start-private-browser --force-device-scale-factor=1.25 google.com"
    echo "            $ start-private-browser --force-device-scale-factor=0.95 google.com"
    echo ""
    echo "            # start browser with spcific user-agent overide (example is FireFox for Windows)"
    echo "            $ start-private-browser --user-agent=\"Mozilla/5.0 (Windows NT x.y; Win64; x64; rv:10.0) Gecko/20100101 Firefox/10.0\""
    echo ""
    echo "            # start a brave instance with remote debugging enabled"
    echo "            $ start-private-browser --remote-debugging-port=9222"
    echo ""
    echo "            # connect to the remote debugging port on the local host (setup in the example above) using curl"
    echo "            $ curl \"http://localhost:9222/json\""
    echo ""
    echo ""
    echo ""
    exit 0
fi

# setup tail runtime timeout value for --auto-monitoring option
which timeout 2>&1 >> /dev/null ; timeout_available=${?}
if [[ ${timeout_available} == 0 ]] ; then
    timeout_available="true"
else
    timeout_available="false"
fi

# kick off update
if [[ "${update_wanted}" == "yes" ]] ; then
    update_script_path_absolute="${update_script_path/#\~/$HOME}"
    if [ -x ${update_script_path_absolute} ] ; then
        updating_fish_snippits_message=""
        if $(which fish 2>&1 >> /dev/null) ; then
            updating_fish_snippits_message=" and related fish snippets"
        fi
        echo "" 
        echo "Preparing to update SPB${updating_fish_snippits_message}."
        echo ""
        echo "   If you have questions, do not proceed. You may consult the "
        echo "   spb-update.bash help by issuing the command directly below : " ; echo ""
        echo "       ${update_script_path} --help | less"
        echo ""
        echo "    If you decide to proceed, then SPB${updating_fish_snippits_message}"
        echo "    will be updated by executing the following command :" ; echo ""
        echo "       ${update_script_path} ${update_script_arguments}" ; echo ""
        echo -n " Do you wish to proceed with this update? [Y/n] : "
        read  auto_update_proceed
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
               exit -164
          fi
        ${update_script_path_absolute} ${update_script_arguments}
        exit ${?}
    else
        echo "ERROR! : Unable to locate the SPB update script : ${update_script_path}"
        exit -165
    fi
fi

# function to validate the template name
function check_template_name() {
    local template_name=${1}
    # prevent reserved template names from being used.
    if [[ "${template_name}" == "available" ]] ; then
          echo ""
          echo "ERROR! : Using that template name \"${template_name}\" is not possible. It is reserved as a direrctory for"
          echo "         storing available templates which may enabled by symlinking them into the spb-template directory."
          echo ""
          exit -167
    fi
    # prevent template names being used that have spaces or non alpha-numeric characters
    if ! [[ "${template_name}" =~ ^[a-zA-Z0-9._-]+$ ]] ; then
          echo ""
          echo "ERROR! : Using that template name \"${template_name}\" is not possible."
          echo "         Supported template names must be alpha-numeric or supported special characters and they"
          echo "         must also not contain any spaces or tabs."
          echo ""
          echo "         Support special characters allowed template names : "
          echo ""
          echo "          - period      [ \".\" ]"
          echo "          - hyphen      [ \"-\" ]"
          echo "          - undersocre  [ \"_\" ]"
          echo ""
          exit -167
    fi
}

# function used to clean the template lock file ; should anything go wrong during pre-flight checks
function clean_lock_file() {
    rm -f ${template_lock_file_absolute}

}

function check_template_browser_identification() {
    if [[ "${quite_mode}" != "true" ]] ; then
            echo "        Browser compatability check..."
    fi
    if [[ ! -f ${template_browser_id_absolute} ]] || [[ ! -r ${template_browser_id_absolute} ]] ; then
        echo "" ; 
        echo "ERROR! : Unable to read the template browser identification!" 
        echo ""
        echo "         Check permissions are set correctly for your browser"
        echo "         template ID file : " 
        echo ""
        echo "             ${template_browser_id_absolute}"
        echo ""
        clean_lock_file
        exit -71
    fi
    local selected_browser_id_name=$("${spb_browser_path}" --version | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    if [[ ${?} != 0 ]] || [[ "${selected_browser_id_name}" == "" ]] ; then
        echo "" ; echo "ERROR! : Unable to calculate selected browser identification!" ; echo ""
        clean_lock_file
        exit -70
    fi
    local template_browser_id_name=$(cat ${template_browser_id_absolute} | head -n 1 | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    if [[ ${?} != 0 ]] || [[ "${template_browser_id_name}" == "" ]] ; then
        echo "" ; echo "ERROR! : Unable to calculate template browser identification!" ; echo ""
        clean_lock_file
        exit -69
    fi
    if [[ "${selected_browser_id_name}" != "${template_browser_id_name}" ]] ; then
        echo ""
        echo "        ERROR! : Selected browser and template identification do not match!" 
        echo ""
        echo "             Selected Browser ID : ${selected_browser_id_name}"
        echo "             Template browser ID : ${template_browser_id_name}"
        echo ""
        echo "        The selected browser ID and the template ID must match!"
        echo ""
        echo "        If the browser and template data do not match, then we"
        echo "        may corrupt the data or have unexpected results during"
        echo "        browser usage."
        echo ""
        clean_lock_file
        exit -68
    fi
    return 0
}

function check_template_directory_accessability() {
    if [[ "$(cd ${template_dir_parent/#\~/$HOME} > /dev/null 2>&1 && echo 'accessable')" != "accessable" ]] ; then
        echo ""
        echo "ERROR! : Unable to access template directory :"
        echo "         ${template_dir_parent}"
        echo ""
        exit -67
    fi
    return 0
}

function run_post_browser_startup_commands() {
    if [[ "${post_browser_cmd}" != "" ]] ; then
        # try running the post script five times until it succees (if it fails after that many goes give up)
        for post_script_attempt in {1..5} ; do
            sleep 1
            bash -c "${post_browser_cmd}" 2>>/dev/null >>/dev/null
            post_browser_cmd_status=$?
            if [[ ${post_browser_cmd_status} != 0 ]] ; then
                continue
            else
                break
            fi
        done
        if [[ ${post_browser_cmd_status} != 0 ]] ; then
            echo ""
            echo "ERROR! : Post Browser Command Failed (with exit code) : [${post_browser_cmd_status}]"
            echo ""
            exit ${post_browser_cmd_status}
        fi          
    fi
    return 0
}


# show available spb templates
if [[ ${spb_list_templates} == "true" ]] ; then
    # if [[ ${index} != 0 ]] || [[ ${num_args} -gt 1 ]]; then
    #   echo ""
    #   echo "ERROR! : Using the ${arg} option is not compatible with any other"
    #   echo "         arguments / parameters."
    #   echo ""
    #   exit -79
    # fi
    # ls ${template_dir_parent/#\~/$HOME} | grep -v "available" | cat

    # confirm template directory is accessable
    check_template_directory_accessability

    template_dir_parent_dirname=$(dirname ${template_dir_parent})
    awk_cut_point="."

    if [[ "${quite_mode}" != "true" ]] ; then
        echo "" ; echo ""
        echo "SPB Template Notes : "
        echo "When loading, editing or creating templates,"
        echo "you must only specify the template name."
        if [[ "${verbose_mode}" == "true" ]] ; then
            echo ""
            echo "The browser is selected using the"
            echo "--browser option."
            echo ""
            echo "Example to create a new brave template called 'my-brave' :"
            echo ""
            echo "  start-private-browser --browser brave --new-template my-brave"
            echo ""
            echo "For additional infomation use the --help option."
            echo "" ; echo ""
            echo "////////////////////////////////////////////////////////////////////" ; echo ""
            echo "SPB Active Templates Directory : ${template_dir_parent_dirname}" ; echo ""
            echo "////////////////////////////////////////////////////////////////////"
        fi
        echo "" ; echo ""
        echo "SPB Templates List :" 
        echo ""
    fi

    # this monstrosity outputs nicely formatted output when you list the templates
    template_list=$(cd ${template_dir_parent_dirname/#\~/$HOME} && find ./ -maxdepth 2 -type d | grep -v "available" \
    | awk -F "$awk_cut_point" '{print $2}' | awk 'gsub("/", "&")!=1' | sed 's/^\///' \
    | awk '{gsub(/\//, "\t\t")}1' | awk 'NF > 1' | awk '{if($1!=last){if(NR>1)print""};last=$1;print}' \
    | awk '{printf "%s%s%s\n", $1, (length($1) > 7 ? "\t" : "\t\t"), $2}' \
    | sed 's/^/        /' | cat) 

    spb_template_listing_status=${?}
    if [[ "${quite_mode}" == "true" ]] ; then 
        echo "${template_list}" | awk 'NF'
    else
        echo "${template_list}" ; echo ""
    fi
    exit ${spb_template_listing_status}
fi

# process arguments using a for loop (yes it seems crazy but that is the way we are doing it)
# this is a custom arg parser in 2025 :)
for arg in "$@" ; do

  # skip some parameters passed into script
  if [[ "${skip_arg}" == "true" ]] ; then
    skip_arg="false"
    ((index++))
    continue
  fi

  # look ahead for passed argument parameters
  if (( index + 1 < num_args )) ; then
        next_arg="${args[index + 1]}"
  else
        next_arg=""
  fi

  # force stop mode 
  if [[ "${force_stop_mode}" == "true" ]] ; then
    if [[ "${arg}" == "--force-stop" ]] ; then
        if [[ "${next_arg}" != "" ]] ; then
            # validate the argument provided
            force_stop_identifier_valid=$(echo "${next_arg}" | grep ${screen_session_prefix} > /dev/null && echo true)
            if [[ "${force_stop_identifier_valid}" == "true" ]] ; then
                # force stop the instance provided
                echo "Force Stop Mode"
                echo "      Killing Session : ${next_arg}"
                screen -S ${next_arg} -p 0 -X stuff $'\003'
                exit ${?}
            else
                echo ""
                echo "ERROR! : The force stop argument provided is not valad."
                echo ""
                echo "         List currently running (valid) instances by running : "
                echo ""
                echo "                ~/bin/start-private-browser.bash --list"
                echo ""
                exit -148
            fi
        else
            echo ""
            echo "ERROR! : Unable to force stop any instance as no instance name was provided"
            echo ""
            echo "         Force stop usage : "
            echo ""
            echo "                ~/bin/start-private-browser.bash --force-stop <instance-identifier>"
            echo ""
            echo "         List currently running instances : "
            echo ""
            echo "                ~/bin/start-private-browser.bash --list"
            echo "" 
            exit -149
        fi
    else
        continue
    fi
  fi

  # check for standard mode (not incognito)
  if [[ "${arg}" == "--standard" ]] ; then
    # TODO : probably we also want a way to configure this from a configuration file... needs looking at :)
    if [[ "${quite_mode}" != "true" ]] ; then
        if [[ "${use_template_dir_name}" != "" ]] ; then
            echo -n "        " # add a space if we are doing template stuff to keep things looking pretty
            dot_dot_dot="..."
        fi
        echo "Standard Mode Enabled${dot_dot_dot}"
    fi
    standard_mode="true"
    valid_argument_found="true"
  fi

  # check for template or template editing
  if [[ "${arg}" == "--template" ]] || [[ "${arg}" == "--edit-template" ]] ||  [[ "${arg}" == "--new-template" ]] ; then
        # check they are not listed more than once
        if [[ "${edit_template_dir_name}" != "" ]] || [[ "${use_template_dir_name}" != "" ]] || [[ "${new_template_dir_name}" != "" ]] ; then
            echo ""
            echo "ERROR! : Using the ${arg} option is only allowed once"
            echo ""
            exit -75
        fi
        if [[ "${next_arg}" != "" ]] ; then
            # configure the system to skip the next argument for processing 
            # as it is the value for this one
            skip_arg="true"
            valid_argument_found="true"
            check_template_name "${next_arg}"
            # update template variables 
            if [[ "${arg}" == "--edit-template" ]] ; then
                edit_template_dir_name="${next_arg}"
                edit_template_dir_absolute="$(echo ${template_dir_parent/#\~/$HOME}/${edit_template_dir_name})"
                if [[ "${quite_mode}" != "true" ]] ; then
                    echo "Editing existing SPB template : ${edit_template_dir_absolute}"
                fi
                # used for storing and retrieving browser template identification
                template_browser_id_absolute="${edit_template_dir_absolute}/${template_browser_id_filename}"
            elif [[ "${arg}" == "--new-template" ]] ; then
                new_template_dir_name="${next_arg}"
                new_template_dir_absolute="$(echo ${template_dir_parent/#\~/$HOME}/${new_template_dir_name})"
                if ! [ -d $(echo ${template_dir_parent/#\~/$HOME}) ] ; then
                    mkdir -p $(echo ${template_dir_parent/#\~/$HOME})
                    if [[ ${?} == 0 ]] ; then
                        if [[ "${quite_mode}" != "true" ]] ; then
                            echo "Created SPB template direcotry : ${template_dir_parent/#\~/$HOME}"
                        fi
                    else
                        echo "" ; echo "ERROR! : Unable to create SPB template directory : ${template_dir_parent/#\~/$HOME}" ; echo ""
                        exit -23
                    fi
                fi
                if [ -d ${new_template_dir_absolute} ] ; then
                    # existing template was found
                    echo ""
                    echo "ERROR! : Unable to create new SPB template" ; echo ""
                    echo "         Existing template with name \"${new_template_dir_name}\" already exists : "
                    echo "         ${new_template_dir_absolute}" ; echo ""
                    echo "         Perhaps you meant to use the [ --edit-template ] or [ --template ] option?"
                    echo ""
                    exit -22
                else
                    # create the new template directory
                    mkdir "${new_template_dir_absolute}"
                    if [[ ${?} == 0 ]] ; then
                        if [[ "${quite_mode}" != "true" ]] ; then
                            echo "Created new SPB template : ${new_template_dir_absolute}"
                        fi
                    else
                        echo "" ; echo "ERROR! : Unable to create new SPB template : ${new_template_dir_absolute}" ; echo ""
                        exit -21
                    fi
                    # mop up the new mess as we will now be using the template
                    edit_template_dir_name="${new_template_dir_name}"
                    edit_template_dir_absolute="$(echo ${template_dir_parent/#\~/$HOME}/${edit_template_dir_name})"
                    new_template_dir_name=""
                    new_template_dir_absolute=""
                    creating_new_template="true"
                fi
                # used for storing and retrieving browser template identification
                template_browser_id_absolute="${edit_template_dir_absolute}/${template_browser_id_filename}"
            else
                # TODO : probably we also want a way to configure this from a configuration file... needs looking at :)
                use_template_dir_name="${next_arg}"
                use_template_dir_absolute="$(echo ${template_dir_parent/#\~/$HOME}/${use_template_dir_name})"
                if [[ "${quite_mode}" != "true" ]] ; then
                    echo "Loading SPB template : ${use_template_dir_absolute}"
                fi
                # check that directory exists
                if ! [ -d ${use_template_dir_absolute} ] ; then
                    echo ""
                    echo "ERROR! : Using the ${arg} option requires specifying a template name"
                    echo "         which matches an existing template."
                    echo ""
                    echo "         The template specified was not found : "
                    echo "         ${template_dir_parent}/${use_template_dir_name}"
                    echo ""
                    echo "         List available templates with the command below : "
                    echo "         ${0} --list-templates"
                    echo ""
                    exit -78
                fi
                # check that the directory is accessable
                check_template_directory_accessability
                # used for storing and retrieving browser template identification
                template_browser_id_absolute="${use_template_dir_absolute}/${template_browser_id_filename}"
            fi

      else
          echo ""
          echo "ERROR! : Using the ${arg} option requires specifying a template name"
          echo "         for an existing template directory."
          echo ""
          echo "         Run command below for list of valid templates : "
          echo "         ~/bin/start-private-browser.bash --list-templates"
          echo ""
          exit -77
      fi
  fi

  # this is disabled so we can pass arguments which are unknown along to brave... 
  # potentially we could have a list of accepted arguments to pass along (maybe?)
  # 
  # # check if this is an argument starting with - or --
  # arg_check=$(echo ${arg} | sed -n 's/^\(--\?\).*/\1/p')
  # if [[ "${arg_check}" == "-" ]] || [[ "${arg_check}" == "--" ]] ; then
  #   if [[ "${valid_argument_found}" == "false" ]] ; then
  #     echo ""
  #     echo "ERROR! : Unknown argument provided : ${arg}"
  #     echo ""
  #     exit -79
  #   fi
  # fi

  ((index++))

done

# prevent --edit-template and --template options being used together
if [[ "${edit_template_dir_name}" != "" ]] && [[ "${use_template_dir_name}" != "" ]] ; then
      echo ""
      echo "ERROR! : Using the the --template and --edit-template options together is not yet supported"
      echo ""
      exit -166
fi



##
## Pre flight checks
## 

function report_no_display_detected() {
    echo ""
    echo "ERROR! : Unable to detect any connected graphical display(s) for this shell!"
    echo "         Ensure your shell is connected to a graphical session and try again."
    echo ""
    exit -77
}

# check the operating system ; also check on brave and screen availability on system
if [[ "${os_type}" == "darwin" ]] ; then
    # running on macOS
    if [[ -z "$spb_browser_path" ]] ; then
        # check this value has not been configured via configuration file / environment variable
        if [[ "${spb_default_multi_browser_support}" == "true" ]] ; then
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type]}"
        else
            # rocking an older version of bash so we stick with brave
            spb_browser_path="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
        fi
    fi
    # check for graphical connection
    if ! launchctl print gui/$(id -u) 2>/dev/null | grep -q 'session = Aqua' ; then report_no_display_detected ; fi
    if [[ -x "${spb_browser_path}" ]] ; then spb_browser_available=0 ; else spb_browser_available=1 ; fi
    mktemp_options="-d"
    du_apparent_size_option="-A"
elif [[ "${os_type}" == "linux" ]] ; then
    # running on GNU/LINUX
    distro=$(grep ^ID= /etc/os-release | awk -F "=" '{print $2}' )
    if [[ "${distro}" == "linuxmint" ]] ; then distro="mint" ; fi
    if [[ -z "$spb_browser_path" ]] ; then
        # check this value has not been configured via configuration file / environment variable
        if [[ "${spb_default_multi_browser_support}" == "true" ]] ; then
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type:$distro]}"
            if [[ "${spb_browser_path}" == "" ]] ; then
                # rocking unsupported distribution so just take a punt with common brave executable names
                which brave 2>&1 >> /dev/null && spb_browser_path="brave"
                which brave-browser >> /dev/null && spb_browser_path="brave-browser"
                if [[ "${spb_browser_name}" != "brave" ]] ; then
                    spb_browser_name="brave"
                    echo ""
                    echo "WARNING! : The browser name has been reverted to \"brave\""
                    echo "           This script ran the following command : "
                    echo "           spb_browser_name=\"brave\""
                    echo ""
                    echo "           A different name was requested but the operating"
                    echo "           system you are using is not currently supported"
                    echo "           by SPB. Feel free to put in a pull request or "
                    echo "           open an issue."
                    echo 
                fi
            fi 
        else
            # rocking an older version of bash so we stick with brave
            spb_browser_path="brave-browser"
        fi
    fi
    if [[ "$(echo $DISPLAY)" == "" ]] ; then report_no_display_detected ; fi
    which ${spb_browser_path} 2>&1 >> /dev/null ; spb_browser_available=${?}
    mktemp_options="--directory"
    du_apparent_size_option="--apparent-size"
elif [[ "$(uname)" == "freebsd" ]] ; then
    # running on  FreeBSD
    if [[ -z "$spb_browser_path" ]] ; then
        # check this value has not been configured via configuration file / environment variable
        if [[ "${spb_default_multi_browser_support}" == "true" ]] ; then
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type]}"
        else
            # rocking an older version of bash so we stick with brave
            spb_browser_path="brave-browser"
        fi
        
    fi
    if [[ "$(echo $DISPLAY)" == "" ]] ; then report_no_display_detected ; fi
    which ${spb_browser_path} 2>&1 >> /dev/null ; spb_browser_available=${?}
    mktemp_options="-d"
    du_apparent_size_option="-A"
else
    echo "ERROR! : Unsupported operating system."
    echo ""
    echo "              Please note this script requires a POSIX compliant"
    echo "              or at minimum a POSIX like operating system"
    echo ""
    exit -99
fi

# report if specified browser is not available on this system, then report the problem
if [[ ${spb_browser_available} != 0 ]] ; then
    echo "ERROR! : Unable to locate specified browser on your system."
    echo ""
    echo "         Ensure that ${spb_browser_name} is installed on your system and that the "
    echo "         correct path is configured within your PATH environment variable."
    echo ""
    echo "         The spb_browser_path (environment variable) currently set is displayed below : "
    echo "         ${spb_browser_path}"
    echo ""
    if [[ "${spb_browser_name}" == "brave" ]] ; then
    echo "         Instructions to install ${spb_browser_name} are available from the URL below : "
    echo "         https://brave.com/download/"
    fi
    if [[ "${spb_browser_name}" == "vivaldi" ]] ; then
    echo "         Instructions to install ${spb_browser_name} are available from the URL below : "
    echo "         https://vivaldi.com/download/"
    fi
    if [[ "${spb_browser_name}" == "chromium" ]] ; then
    echo "         Instructions to install ${spb_browser_name} are available from the URL below : "
    echo "         https://www.chromium.org/getting-involved/download-chromium/"
    fi
    echo ""
    exit -1
fi


# report if screen is not available
which screen 2>&1 >> /dev/null ; screen_available=${?}
if [[ ${screen_available} != 0 ]] ; then
    echo "ERROR! : Unable to locate screen on your system."
    echo ""
    echo "         Ensure that screen is installed on your system and that the "
    echo "         correct path is configured within your PATH environment variable."
    echo ""
    echo "         Official instructions to install screen are available from the URL below : "
    echo "         https://www.gnu.org/software/screen/"
    echo ""
    echo "         Non-Offical instructions to install screen on LINUX are available from the URL below : "
    echo "         https://linuxtldr.com/installing-screen/"
    echo ""
    echo "         Non-Offical instructions to install screen on FreeBSD are available from the URL below : "
    echo "         https://joshdawes.com/installing-screen-for-freebsd/"
    echo ""
    exit -1
fi

# configure general template editing and loading variables
if [[ "${edit_template_dir_name}" != "" ]] ||  [[ "${use_template_dir_name}" != "" ]] ; then
    if [[ "${edit_template_dir_name}" != "" ]] ; then
        # this is a template we are editing
        template_lock_file_absolute=${edit_template_dir_absolute}/${spb_template_lock_file_name}
    else
        # this is a template we will be using
        template_lock_file_absolute=${use_template_dir_absolute}/${spb_template_lock_file_name}
    fi
    if [ -e ${template_lock_file_absolute} ] ; then
        spb_screen_identifier_error_read_message="ERROR! : Unable read SBP screen identifier from lock file!"
        spb_screen_session_template_lock_identifier=$(cat ${template_lock_file_absolute} || echo ${spb_screen_identifier_error_read_message})
        if [[ "${spb_screen_session_template_lock_identifier}" == "" ]] ; then
            spb_screen_session_template_lock_identifier="${spb_screen_identifier_error_read_message}"
        fi
    fi
fi


# function for reporting browser template locks
function report_general_browser_lock_file_information() {
    echo ""
    echo "             SPB session identifier which locked this template :"
    echo "                 ${spb_screen_session_template_lock_identifier}"
    if [[ "${spb_screen_identifier_error_read_message}" == "${spb_screen_session_template_lock_identifier}" ]] ; then
        echo "                          The lock file has some sort of issue."
    fi
    echo ""
    echo "             Currently running SPB session list : "
    # list the running spb sessions on this system and highlight the locked file with grep
    if [[ "${spb_screen_identifier_error_read_message}" == "${spb_screen_session_template_lock_identifier}" ]] ; then
        $0 --list | sed 's/^[0-9][0-9]*\.//' | sed 's/^/                 /' 
    else
        $0 --list | sed 's/^[0-9][0-9]*\.//' | grep --color=always -e '^' -e ${spb_screen_session_template_lock_identifier} | sed 's/^/                 /' 
    fi
    echo ""
    # check the running spb sessions and see if there is a match for the lock file
    template_lock_file_culprit_found_in_running_spb_session="false"
    if [[ "${spb_screen_identifier_error_read_message}" != "$spb_screen_session_template_lock_identifier" ]] ; then
        template_lock_file_culprit_found_in_running_spb_session=$( $0 --list | sed 's/^[0-9][0-9]*\.//' | grep -x "${spb_screen_session_template_lock_identifier}" > /dev/null && echo "true")
    fi
    if [[ ${template_lock_file_culprit_found_in_running_spb_session} != "true" ]] ; then
        echo "         The SPB session identifier which reportedly locked this"
        echo "         template was ***NOT*** found in the list of running SPB sessions!"
        echo ""
        echo "         Perhaps the machine was restarted or some other error"
        echo "         event occoured while the template was being edited?"
        echo ""
        echo "         You could run the following command to manually remove the lock file :"
        echo ""
        echo "             rm -i ${template_lock_file_absolute}"
        echo ""
        echo "         Once removed, you could then attempt re-running your command."
    else
        if [[ "${os_type}" != "darwin" ]] ; then
            echo "         Sometimes browsers take a while to exit after you close the last window."
        fi
        if [[ "${os_type}" == "darwin" ]] ; then
            echo "         Sometimes browsers take a while to exit after they have been quit."
            echo ""
            echo "         Remember on macOS you must specifically quit the browser as closing"
            echo "         the browser windows, will not quit the browser. Select the browser"
            echo "         within the Dock and then select 'Quit' from the 'File' menu."
        fi
        echo "         If you are sure your browser has exited ; wait a little"
        echo "         longer and then try re-running your command."
        echo ""
        process_id_to_kill=$($0 --list | grep "${spb_screen_session_template_lock_identifier}" | awk -F "." '{print $1}')
        if [[ ${process_id_to_kill} != "" ]] ; then
            echo "         IMPORTANT NOTE : Rather than issuing either of the commands below. It is strongly"
            echo "         recommended that you simply wait for the browser to shutdown gracefully ; in order"
            echo "         to avoid corruption of the template data."
            echo ""
            echo "         If you decide to forcefully stop the process, consider issuing the following command : "
            echo "             ~/bin/start-private-browser.bash --force-stop ${spb_screen_session_template_lock_identifier}"
            echo ""
            echo "         The command above will send a control-c (AKA SIGINT or Signal Interrupt)"
            echo "         to the browser process (see important note above)."
            echo ""
            echo "         Should that command above fail you may also consider killing the screen"
            echo "         process using the command below (see important note above) :"
            echo "              kill ${process_id_to_kill}"
            echo ""
            echo "         If you run either of the commands above, just wait a moment and then"
            echo "         proceed to re-run your command."
            echo ""
        fi

    fi
    echo ""
}

function create_template_browser_identification() {
    # creating a new template
        if [[ "${template_browser_id_absolute}" != "" ]] ; then
            if [[ "${quite_mode}" != "true" ]] ; then
                echo "        Storing browser information..."
            fi
            "${spb_browser_path}" --version > ${template_browser_id_absolute}
            if [[ ${?} != 0 ]] ; then
                echo "" ; echo "        WARNING! : Unable save browser information into within the template."
            fi
        else
            echo "ERROR! : Unable to resolve absolute path for template data."
            clean_lock_file
            exit -75
        fi
}

# template copying pre-flight checks
if [[ "${use_template_dir_name}" != "" ]] ; then
    if [ -e ${template_lock_file_absolute} ] ; then
        echo ""
        echo "ERROR! : The template you are attempting to load contains an SPB edit lock :"
        echo "         ${template_lock_file_absolute}"
        echo ""
        echo "         It is likely that you are currently editing this template."
        echo "         As such loading this the template is not possible."
        report_general_browser_lock_file_information
        if [[ "${spb_screen_session_template_lock_identifier}" == "${spb_screen_identifier_error_read_message}" ]] ; then
            exit -211
        fi
        exit -58
    fi
fi

# template editing pre-flight checks
if [[ "${edit_template_dir_name}" != "" ]] ; then
    # confirm no lock file exits for this template
    if [ -e ${template_lock_file_absolute} ] ; then
        echo ""
        echo "ERROR! : The template you are attempting to edit contains an SPB edit lock :"
        echo "         ${template_lock_file_absolute}"
        echo ""
        echo "         You are probably already editing this template."
        echo "         As such, editing this the template is not possible."
        report_general_browser_lock_file_information
        if [[ "${spb_screen_session_template_lock_identifier}" == "${spb_screen_identifier_error_read_message}" ]] ; then
            exit -212
        fi
        exit -56
    fi
    # create the lock file to prevent others from editing
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Creating template editing lock..."
    fi
    touch ${template_lock_file_absolute}
    if [[ ${?} != 0 ]] ; then
        echo ""
        echo "ERROR! : Failed to create SPB edit lock :"
        echo "         ${template_lock_file_absolute}"
        echo ""
        echo "         Check permissions for this SPB template."
        echo "         Editing this the template is not possible at this time."
        echo ""
        exit -57
    fi
    # configure edit template lock file removal command
    spb_etlfr_cmd="; rm -f ${template_lock_file_absolute}"
fi


##
## Now we commence with take off
## 

# create a temporary directory and setup the permissions so that only your user has access to the directory
if ! [ -d ${spb_temp_data_path} ] ; then
    echo "ERROR! : Unable to locate the temporary user data parent directory : "
    echo "         ${spb_temp_data_path}"
    exit -5
fi

browser_tmp_directory=$(mktemp ${mktemp_options} ${temp_path}-$(whoami)-XXXXX)
if [[ $? != 0 ]] || [[ ! -d ${browser_tmp_directory} ]] ; then
    echo "ERROR! : Unable to create temporary user data directory"
    exit -2
fi
chmod 700 ${browser_tmp_directory}
if [[ $? != 0 ]] ; then
    echo "ERROR! : Unable set permissions correctly for temporary user data directory"
    exit -3
fi



# calculate the screen session name
screen_session_name="${screen_session_prefix}-$(echo "${browser_tmp_directory}" | awk -F "${temp_path}-" '{print$2}')"


# templating (copy the template over)
if [[ "${use_template_dir_name}" != "" ]] ; then

    if [[   -e ${template_browser_id_absolute} ]] && [[ "${template_browser_id_absolute}" != "" ]] ; then
        check_template_browser_identification
    else
        echo ""
        echo "          WARNING : Unable to locate template browser id file :"
        echo ""
        echo "              ${template_browser_id_absolute}"
        echo ""
        echo "          Please be sure this selected template is compatible with your browser!"
        echo ""
        echo "          Currently selected browser is : \"${spb_browser_name}\""
        echo ""
        echo "          If this is not the correct browser for this template,"
        echo "          it is possible to use the '--browser' option to switch browsers."
        echo ""
        echo "          Example usage below demonstrates how to select the brave browser : "
        echo ""
        echo "          ~/bin/start-private-browser.bash --browser brave"
        echo ""
        echo "          If there is a browser mismatch ***DATA CURRUPTION*** is extremely likely!"
        echo ""
        echo "          Continuing will generate the template browser id and if successful,"
        echo "          the next step will be to load the requested template."
        echo ""
        echo "          If you do not answer within 60 seconds then we will NOT proceed."
        echo ""
        echo -n "          Would you like to proceed? [y/N] : "
        proceed_with_unconfirmed_browser_identification=""
        proceeded_automatically=" (manually)"
        read -t 60 proceed_with_unconfirmed_browser_identification
        proceed_with_timeout_result=${?}
        if [[ ${proceed_with_timeout_result} != 0 ]] ; then echo "" ; proceeded_automatically=" (automatically)" ; fi 
        if \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "y" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "Y" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "yes" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "Yes" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "YES" ]] \
        ; then 
            echo ""
            echo "          Template loading aborted${proceeded_automatically} due to possibility of data corruption."
            echo "          This is due to possible selected browser and template mismatch!"
            echo ""
            exit -223
        else
            echo ""
            create_template_browser_identification
        fi
    fi

    # template specific varables used to control the template copy
    template_copy_progress_bar_possible="false"
    template_copy_mac_clone_possible="false"
    template_copy_clone_argument=""

    # calculate if running on macOS if using cp is going to be faster than tar
    if [[ "${os_type}" == "darwin" ]] ; then
        # find the file system type of the tempoary directory
        darwin_browser_tmp_dir_file_system_type=$(diskutil info $(df ${browser_tmp_directory} | tail -n 1 | awk '{print $1}') | grep "File System Personality" | awk -F "File System Personality:   " '{print $2}' )
        if [[ "${darwin_browser_tmp_dir_file_system_type}" == "APFS" ]] ; then
            # the temporary directory is on an APFS volume (which if the source we copy from is APFS, then we should use cp rather than tar)
            if [[ $(stat -f %d ${browser_tmp_directory})  == $(stat -f %d ${use_template_dir_absolute}) ]] ; then
                # we are copying on the same volume and this is APFS so we will use cp because it is really fast
                template_copy_progress_bar_possible="false"
                template_copy_mac_clone_possible="true"
                template_copy_clone_argument="-c"
            fi
        fi
    fi

    # check which programs are installed on this system for displaying progress bar while making a copy of the template
    if [[ "${quite_mode}" != "true" ]] && [[ "${template_copy_mac_clone_possible}" == "false" ]]; then
        if [[ "${template_show_progress_bar}" == "true" ]] ; then
            which gcp 2> /dev/null 1> /dev/null ; gcp_available=${?}
            if [[ ${gcp_available} == 0 ]] && [[ ${os_type} != "darwin" ]] ; then
                gcp_available="true"
                template_copy_progress_bar_possible="true"
            else
                gcp_available="false"
                which pv 2> /dev/null 1> /dev/null ; pv_available=${?}
                if [[ ${pv_available} == 0 ]] ; then
                    pv_available="true"
                    which 2> /dev/null 1> /dev/null ; tar_available=${?}
                    if [[ ${tar_available} == 0 ]] ; then
                        tar_available="true"
                        template_copy_progress_bar_possible="true"
                    else
                        tar_available="false"
                    fi
                else
                    pv_available="false"
                fi
            fi
            if [[ "${template_copy_progress_bar_possible}" == "true" ]] ; then
                template_data_disk_usage_megabytes=$(du -s -m ${du_apparent_size_option} ${use_template_dir_absolute} | awk '{print $1}')
            fi
        fi
    fi

    # report copying template data unless quite mode enabled
    if [[ "${quite_mode}" != "true" ]] ; then
        template_data_disk_usage_human=$(du -hs ${du_apparent_size_option} ${use_template_dir_absolute} | awk '{print $1}')
        if [[ "${template_copy_mac_clone_possible}" == "true" ]] ; then
            template_copy_or_clone="Cloning"
        else
            template_copy_or_clone="Copying"
        fi
        echo "        ${template_copy_or_clone} ${template_data_disk_usage_human}B template data..."
    fi

    # copy the data (showing the progress or not depending on settings)
    if [[ "${quite_mode}" != "true" ]] && [[ "${template_copy_progress_bar_possible}" == "true" ]] && [[ ${template_data_disk_usage_megabytes} -gt ${template_size_to_show_progress_bar} ]] ; then
        # copy template with progress bar
        if [[ "${gcp_available}" == "true" ]] ; then
            gcp -r ${use_template_dir_absolute}/* ${browser_tmp_directory}/
            template_copy_status=${?}
        else
            tput civis # hide terminal cursor
            tar -C ${use_template_dir_absolute} -cf - ./ | pv -s ${template_data_disk_usage_megabytes}M | tar -C ${browser_tmp_directory} -xf -
            template_copy_status=${?}
            tput cnorm # bring back terminal cursor
        fi
        echo -ne "\033[A\033[K" # erase the progress bar once the copy process has completed
    else
        # copy template but do not show bar
        cp ${template_copy_clone_argument} -r ${use_template_dir_absolute}/. ${browser_tmp_directory}/
        template_copy_status=${?}
    fi
    if [[ ${template_copy_status} != 0 ]] ; then
        echo ""
        echo "ERROR! : Unable to copy template into place"
        rm -rf ${browser_tmp_directory}
        exit -5
    fi

    # sync the file system at the required paths (macos will sync everything)
    if [[ "${quite_mode}" != "true" ]] ; then
        # echo "          [ ${template_data_disk_usage_human}B transferred ]"
        echo "        Synchronizing filesystem..."
    fi
    sync --file-system ${browser_tmp_directory}
fi

# check if we are we using firefox, palemoon or zen (experimental)
if [[ "${spb_browser_name}" == "firefox" ]] || [[ "${spb_browser_name}" == "palemoon" ]] || [[ "${spb_browser_name}" == "zen" ]] ; then 
    incognito_options="--private-window"
    spb_data_browser_specifc_options="--new-instance --no-remote --class CustomClass --profile "
    if [[ "${spb_browser_name}" == "zen" ]] ; then 
         spb_data_browser_specifc_options="--new-instance --no-remote --profile "
         if [[ ${os_type} == "darwin" ]] ; then
            # bring the zen to the front if running on macOS
            post_browser_cmd="osascript -e 'tell application \"Zen\" to activate'"
        fi
    fi
elif [[ "${spb_browser_name}" == "opera" ]] ; then
    # check if we are using opera (experimental)
    incognito_options="--private"
    spb_data_browser_specifc_options="--no-first-run --disable-first-run-ui --user-data-dir="
else
    # anything else use the defaults from chromium based browsers
    incognito_options="--incognito"
    spb_data_browser_specifc_options="--user-data-dir="
fi

# check if we are we running in standard mode
if [[ "${standard_mode}" == "true" ]] ; then 
    if [[ "${spb_browser_name}" == "firefox" ]] || [[ "${spb_browser_name}" == "palemoon" ]] ; then 
        incognito_options="--new-window"
    else
        # not running incognito mode (eg standard mode)
        incognito_options=""
    fi
fi

# check if we are editing a template
if [[ "${edit_template_dir_name}" != "" ]] ; then

    # saving the session details into the lock file
    echo "${screen_session_name}" > ${template_lock_file_absolute}
    if [[ ${?} != 0 ]] ; then
        echo "        WARNING! : Unable to save session details within the lock file."
    fi

    # temp directory is not used for this session (keeping the data and saving into the template)
    user_data_directory_options="${spb_data_browser_specifc_options}${edit_template_dir_absolute}"
    
    # create a sym-link within that directory to the template for clarity
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Linking to template data..."
    fi
    ln -s "${edit_template_dir_absolute}" ${browser_tmp_directory}/loaded_template.link 2>/dev/null
    if [[ ${?} != 0 ]] ; then
        echo "" ; echo "        WARNING! : Unable establish symlink within temporary directory to the template."
    fi

    # create or check template browser identification file (used to ensure compatability of templates)
    if [[ "${creating_new_template}" == "true" ]] ; then
        create_template_browser_identification
    else
        # editing existing template
        if [[ -e ${template_browser_id_absolute} ]] && [[ "${template_browser_id_absolute}" != "" ]] ; then
            # template browser id file found so confirm it is compatible with browser
            check_template_browser_identification
        else
            echo "ERROR! : Unable to locate template browser id file : "
            echo "         ${template_browser_id_absolute}"
            clean_lock_file
            exit -73
        fi
    fi

    # sync the file system at the required paths (macos will sync everything)
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Synchronizing filesystems..."
    fi
    sync --file-system ${browser_tmp_directory}
    sync --file-system ${edit_template_dir_absolute}

else
    # standard usage # using the temp directory (delete when browser closes)
    user_data_directory_options="${spb_data_browser_specifc_options}${browser_tmp_directory}"
fi

# report temporary directory information and screen session name in verbose mode
if [[ "${quite_mode}" != "true" ]] ; then
    if [[ "${verbose_mode}" == "true" ]] ; then 
        echo "Screen session name : ${screen_session_name}"
        echo "Temporary directory : ${browser_tmp_directory}"
    fi
fi

# parse the arguments for options and URL's to pass to brave.
browser_options="${user_data_directory_options} ${incognito_options}"
url_list=""
while [[ ${#} -ge 1 ]] ; do
    # note, that no additional checking for validly of options is performed.
    # maybe in a future version of this script.
    if [[ $(echo "${1}" | grep -e "^-") ]] ; then
        browser_option_name=$(echo "${1}" | sed -n 's/.*--\([^=]*\)=.*/\1/p')
        browser_option_value=$(echo "${1}" | sed 's/^[^=]*=//')
        if [[ ${browser_option_name} != "" ]] && [[ ${browser_option_value} != "" ]] ; then
            new_browser_argument="--${browser_option_name}=\"${browser_option_value}\""
            browser_options="${browser_options} ${new_browser_argument}"
        else
            if [[ "${1}" != "--browser" ]] && [[ "${1}" != "--browser-path" ]]  && [[ "${1}" != "--template" ]] && [[ "${1}" != "--new-template" ]] && [[ "${1}" != "--edit-template" ]] && [[ "${1}" != "${--template-path}" ]] ; then
                browser_options="${1} ${browser_options}"
            fi
        fi
    else
        if [[ "${1}" != "${spb_browser_name}" ]] && [[ "${1}" != "${spb_browser_path}" ]] && [[ "${1}" != "${use_template_dir_name}" ]] && [[ "${1}" != "${edit_template_dir_name}" ]] && [[ "${1}" != "${template_dir_base_default_override}" ]] ; then
            # build the URL list (but exclude the spb_browser_name, template and edit-template data which may be have been provided)
            url_list="${url_list} \"${1}\""
        fi
    fi
    shift
done

# start a screen session with the name based off the temp directory, then once browser exits delete the temporary directory
screen -S "${screen_session_name}" -dm bash -c " \"${spb_browser_path}\" ${browser_options} ${url_list} ; sleep 1 ; sync ; rm -rf ${browser_tmp_directory} ${spb_etlfr_cmd} "

# run post browser commands
run_post_browser_startup_commands

exit 0



