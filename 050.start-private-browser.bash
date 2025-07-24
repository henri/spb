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
# Henri Shustak 2024
#
# Released under the GNU GPLv3 or later licence :
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
# version 1.5 - initial support for passing additional options to brave implimented (note : zero checking of option validity)
# version 1.6 - updates to the help output\
# version 1.7 - added url to download brave if it is not installed
# version 1.8 - added user-agent usage example
# version 1.9 - added additional sanity check
# version 2.0 - addeditional requirement check that screen is installed before doing anything
# version 2.1 - bug fix related to screen detection
# version 2.2 - minor improvement when listing active sessions
# version 2.3 - added additional usage notes
# version 2.4 - added improved support for displaying help
# version 2.5 - improved option parsing system
# version 2.6 - initial foundations for templating sub-system implimented
# version 2.7 - improved option parsing to allow for greater felxibility
# version 2.8 - increased verbosity of output while loading template data
# version 2.9 - added locking to the templates and squashed bugs
# version 3.0 - added standard option to not start incognito mode
# version 3.1 - added a quite mode option for less verbose output
# version 3.2 - prevent coping a template while it is being edited
# version 3.3 - improved template lock file session support, improved template support and squashed bugs
# version 3.4 - reporting and error handling relating to lock files improved
# version 3.5 - further improvments to template lock file subsystem reliability and user support dialog
# version 3.6 - cross platform compatibility enhancment
# version 3.7 - added a force stop command (to kill an spb session)
# version 3.8 - foundation laid for the template system to support browser comptability
# version 3.9 - further improvements to multi-browser support within the templating system
# version 4.0 - added update option support
# version 4.1 - minor improvments to output relating to updates
# version 4.2 - bug fixs
# version 4.3 - altered configuration defaults working towards improved browser compatibaility
# version 4.4 - prepared multi-browser compatibility foundations
# version 4.5 - initial templating compatibility checks implimented
# version 4.6 - improved template listing output in relation to multi-browser improvements
# version 4.7 - bug fixs relating to older versions of bash
# version 4.8 - improvements to mutli-browser compatability
# version 4.9 - initial enviroment variable support for spb browser configuration
#

##
## Configuration of Varibles
## 

# configuration variables
screen_session_prefix="spb-session"                 #  prefix of the screen session name
temp_path="/tmp/browser"                            #  location of temporary browser data
template_dir_parent="~/bin/spb-templates"           #  location of spb templates
template_browser_id_filename="spb-browser.id"       #  file which will contain the browser identifier for this template
update_script_path="~/bin/spb-update.bash"          #  where to find the spb-update script
update_script_arguments="--auto-monitoring"         #  arguents passed to update script when running an update
spb_configuration_file_name="spb.config"

# lock file varables to protect tempaltes being edited
spb_template_lock_file_name="spb-template-edit.lock"
spb_etlfr_cmd="" # spb edit template lock file remove command (leave this blank it is automatically updated when required)

# setup varabels for processing arguments we ares pecifcially NOT using get opts 
args=("$@")
index=0
num_args=$#

# configure the default SPB browser name
spb_browser_name_default="brave"
spb_browser_is_default="true"
spb_browser_name_externally_configured="false"
if [[ -z "$spb_browser_name" ]] ; then
    # check this value has not been configured via configuration file / enviroment varable
    spb_browser_name="${spb_browser_name_default}"
else
    # this value has been configured via configuation file / enviroment varable
    spb_browser_name_externally_configured="true"
fi
if [[ "${spb_browser_name_default}" != "${spb_browser_name}" ]] ; then
    # this varable is used to keep track of which variables need to have been set
    # sanity checks in relation to templating subsystem 
    # it is important to ensure the template type 
    # matches the specified browser
    spb_browser_is_default="false"
fi
spb_external_count=0
[[ ! -z "${spb_browser_path}" ]] && spb_external_count=$((spb_external_count+1))
[[ "${spb_browser_name_externally_configured}" == "true" ]] && spb_external_count=$((spb_external_count+1))
if [[ spb_external_count -eq 1 ]] ; then
    # one of these has been set but not both of them (bottle out with a message)
    echo ""
    echo "ERROR! : Unable to proceed eviroment variable problem!"
    echo "         If you configure either of the follwoing envirment varibales :"
    echo ""
    echo "                   spb_browser_name or spb_browser_path"
    echo ""
    echo "         You must configure the other, they either must both be set or"
    echo "         alterativly neither of should be externally configured."
    echo ""
    echo "         This is related to tempalte directory organisation."
    echo ""
    exit -176
fi

# update the template directory parent so that it is browser specific
template_dir_parent="${template_dir_parent}/${spb_browser_name}"     

# updated variables and the defaults
creating_new_template="false"
spb_list_templates="false"

new_template_dir_name=""
edit_template_dir_name=""
use_template_dir_name=""
help_wanted="no"
update_wanted="no"
valid_argument_found="false"
standard_mode="false" # when set to true, we will not default to running incognito window
quite_mode="false"
force_stop_mode="false"
template_browser_id_absolute="" # when creating a new template this is set to the full absolute path to the template browser_id file
spb_configuration_file_path="${template_dir_parent}/${spb_configuration_file_name}" # using the template directory to store the configuration file
spb_configuration_file_absolute="${spb_configuration_file_path/#\~/$HOME}" # expand the home tild if needed
spb_default_multi_browser_support="false"

# default multi-browser support enabled - if we are running bash version 4 or later
if [[ -z ${BASH_VERSINFO} ]] ; then
    if [[ ${BASH_VERSINFO} -ge 4 ]] ; then
        # default browser values - these are the commands which we run on various operating systems for various browsers
        declare -A spb_default_browser_data
        spb_default_browser_data["vivaldi:linux"]="vivaldi"
        spb_default_browser_data["vivaldi:darwin"]="/Applications/Vivaldi.app/Contents/MacOS/Vivaldi"
        spb_default_browser_data["brave:linux"]="brave-browser"
        spb_default_browser_data["brave:darwin"]="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
        spb_default_multi_browser_support="true"
    fi
fi

# internal argument parsing varables
skip_arg="false"
pre_arg_scan_proceed="true"


##
## Argument Processing
## 

# pre argument scanning (arguments which will almost allways end up exiting before we actually start a browser)
for arg in "$@" ; do

  # check for help wanted
  if [[ "${arg}" == "-h" ]] || [[ "${arg}" == "--help" ]] ; then
    help_wanted="yes"
    valid_argument_found="true"
    break
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
  
  # check to see if quite mode should be enabled
  if [[ "${arg}" == "--quite" ]] ; then
    quite_mode="true"
    valid_argument_found="true"
  fi

done

# show available spb templates
if [[ ${spb_list_templates} == "true" ]] ; then
    # if [[ ${index} != 0 ]] || [[ ${num_args} -gt 1 ]]; then
    #   echo ""
    #   echo "ERROR! : Using the ${arg} option is not compatiable with any other"
    #   echo "         arguments / parameters."
    #   echo ""
    #   exit -79
    # fi
    # ls ${template_dir_parent/#\~/$HOME} | grep -v "available" | cat
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "" 
        echo "SPB Template Notes : "
        echo "When loading, editing or creating templates,"
        echo "you must not specify the browser name!"
        echo "Specify only the template name."
        echo ""
        echo "SPB Templates List :"
    fi
    
    teamplate_dir_parent_dirname=$(dirname ${template_dir_parent})
    awk_cut_point=$(basename ${teamplate_dir_parent_dirname})
    find ${teamplate_dir_parent_dirname/#\~/$HOME} -maxdepth 2 -type d | grep -v "available" | awk -F "$awk_cut_point" '{print $2}' | awk 'gsub("/", "&")!=1' | sed 's/^\///' | awk '{gsub(/\//, "\t\t")}1' | cat 
    spb_template_listing_status=${?}
    if [[ "${quite_mode}" != "true" ]] ; then echo "" ; fi
    exit ${spb_template_listing_status}
fi

# show usage information
if [[ "${help_wanted}" == "yes" ]] ; then
    echo ""
    echo "         SPB or 'start-private-browser' is a wrapper to the brave-browser command."
    echo ""
    echo "         This wrapper allows you to quickly start as many sperate instances"
    echo "         of the brave-browser as your system has available memory to run"
    echo "         simultianuusly under a single graphical login."
    echo ""
    echo "         Requirments include gnu/screen and the brave-browser to be installed"
    echo "         on your system. This script has been mildly tested on gnu/linux mint."
    echo "         It is possible this will also work on many other posix compliant"
    echo "         opterating systems. Your miliage may vary."
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
    echo "            # surpress important notification output"
    echo "            $ start-private-browser --quite"
    echo ""
    echo "            # forceably close a browser session if it has hung"
    echo "            $ start-private-browser --force-stop <instance-identifier>"
    echo ""
    echo "            # update the spb system and assosiated fish snippits using default options"
    echo "            $ start-private-browser --update"
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

# kick off update
if [[ "${update_wanted}" == "yes" ]] ; then
    update_script_path_absolute="${update_script_path/#\~/$HOME}"
    if [ -x ${update_script_path_absolute} ] ; then
        updating_fish_snippits_message=""
        if $(which fish >/dev/null) ; then
            updating_fish_snippits_message=" and related fish snippits"
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

# function to valadate the template name
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
    # prevent template names being used that have spaces or non alpha-numeric characteers
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
        echo "ERROR! : Selected browser and template identiciation do not match!" 
        echo ""
        echo "             Selected Browser ID : ${selected_browser_id_name}"
        echo "             Template browser ID : ${template_browser_id_name}"
        echo ""
        echo "         The selected browser ID and the template ID must match!"
        echo ""
        echo "         If the browser and teampate data do not match, then we"
        echo "         may currupt the data or have unexected results during"
        echo "         browser usage."
        echo ""
        clean_lock_file
        exit -68
    fi
    return 0
}


# process arguments using a for loop (yes it seems crazy but that is the way we are doing it)
# this is a custom arg parser in 2025 :)
for arg in "$@" ; do

  # skip some paramaters passed into script
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
            # valadate the argument provided
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
        echo "Standard Mode Enabled"
    fi
    standard_mode="true"
    valid_argument_found="true"
  fi

  # check for tempate or template editing
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
            # update template varables 
            if [[ "${arg}" == "--edit-template" ]] ; then
                edit_template_dir_name="${next_arg}"
                edit_template_dir_absolute="$(echo ${template_dir_parent/#\~/$HOME}/${edit_template_dir_name})"
                if [[ "${quite_mode}" != "true" ]] ; then
                    echo "Editing existing SPB template : ${edit_template_dir_absolute}"
                fi
                # used for storing and retriving browser template identification
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
                    # create the new template directrory
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
                # used for storing and retriving browser template identification
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
                    echo "ERROR! : Using the ${arg} option requires specifing a template name"
                    echo "         which matches an existing template."
                    echo ""
                    echo "         The template specified was not found : "
                    echo "         ${template_dir_parent}/${use_template_dir_name}"
                    echo ""
                    echo "         List available teampltes with the command below : "
                    echo "         ${0} --list-templates"
                    echo ""
                    exit -78
                fi
                # used for storing and retriving browser template identification
                template_browser_id_absolute="${use_template_dir_absolute}/${template_browser_id_filename}"
            fi

      else
          echo ""
          echo "ERROR! : Using the ${arg} option requires specifing a template name"
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

# prevent --edit-template and --template options being used togehter
if [[ "${edit_template_dir_name}" != "" ]] && [[ "${use_template_dir_name}" != "" ]] ; then
      echo ""
      echo "ERROR! : Using the the --template and --edit-template options together is not yet supported"
      echo ""
      exit -166
fi


##
## Pre flight checks
## 

# configuration file loading
if [ -r ${spb_configuration_file_absolute} ] ; then
    # lets start with sourcing, then we can move onto parsing
    source ${spb_configuration_file_absolute}
fi

# check the operating system ; also check on brave and screen availability on system
os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "${os_type}" == "darwin" ]] ; then
    # running on macOS
    if [[ -z "$spb_browser_path" ]] ; then
        # check this value has not been configured via configuration file / enviroment varable
        if [[ "${spb_default_multi_browser_support}" == "true" ]] ; then
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type]}"
        else
            # rocking an older version of bash so we stick with brave
            spb_browser_path="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
        fi
    fi
    if [[ -x "${spb_browser_path}" ]] ; then spb_browser_available=0 ; else spb_browser_available=1 ; fi
    mktemp_options="-d"
elif [[ "${os_type}" == "linux" ]] || [[ "$(uname)" == "freebsd" ]]; then
    # running on GNU/LINUX or FreeBSD
    if [[ -z "$spb_browser_path" ]] ; then
        # check this value has not been configured via configuration file / enviroment varable
        if [[ "${spb_default_multi_browser_support}" == "true" ]] ; then
            spb_browser_path="${spb_default_browser_data[$spb_browser_name:$os_type]}"
        else
            # rocking an older version of bash so we stick with brave
            spb_browser_path="brave-browser"
        fi
    fi
    which ${spb_browser_path} >> /dev/null ; spb_browser_available=${?}
    mktemp_options="--directory"
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
    echo "ERROR! : Unable to locate specificed browser on your system."
    echo ""
    echo "         Ensure that ${spb_browser_name} is installed on your system and that the "
    echo "         correct path is configured within your PATH enviroment variable."
    echo ""
    echo "         The spb_browser_path (enviroment varable) currently set is displayed below : "
    echo "         ${spb_browser_path}"
    echo ""
    if [[ "${spb_browser_name}" == "brave" ]] ; then
    # only brave download instructions are supported at this time.
    echo "         Instructions to install ${spb_browser_name} are available from the URL below : "
    echo "         https://brave.com/download/"
    fi
    echo ""
    exit -1
fi

# report if screen is not available
which screen >> /dev/null ; screen_available=${?}
if [[ ${screen_available} != 0 ]] ; then
    echo "ERROR! : Unable to locate screen on your system."
    echo ""
    echo "         Ensure that screen is installed on your system and that the "
    echo "         correct path is configured within your PATH enviroment variable."
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

# configure general template editing and loading varables
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
        echo "         Once removed, you could then attempt re-runing your command."
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
            echo "         reccomended that you simply wait for the browser to shutdown gracefully ; in order"
            echo "         to avoid curruption of the template data."
            echo ""
            echo "         If you decide to forcfully stop the process, consider issing the following command : "
            echo "             ~/bin/start-private-browser.bash --force-stop ${spb_screen_session_template_lock_identifier}"
            echo ""
            echo "         The command above will send a control-c (AKA SIGINT or Signal Interrupt)"
            echo "         to the browser process (see importantnote above)."
            echo ""
            echo "         Should that command above fail you may also consider killing the screen"
            echo "         process using the commad below (see important note above) :"
            echo "              kill ${process_id_to_kill}"
            echo ""
            echo "         If you run either of the commands above, just wait a moment and then"
            echo "         proceed to re-run your command."
            echo ""
        fi

    fi
    echo ""
}

# template copying pre-flight checks
if [[ "${use_template_dir_name}" != "" ]] ; then
    if [ -e ${template_lock_file_absolute} ] ; then
        echo ""
        echo "ERROR! : The template you are attempting to load contains an SPB edit lock :"
        echo "         ${template_lock_file_absolute}"
        echo ""
        echo "         It is likley that you are currently editing this template."
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

# create a tmporary directory and setup the permissions so that only your user has access to the direcotry
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
    if [[ -e ${template_browser_id_absolute} ]] && [[ "${template_browser_id_absolute}" != "" ]] ; then
        check_template_browser_identification
    else
        echo ""
        echo "WARNING : Unable to locate template browser id file :"
        echo ""
        echo "              ${template_browser_id_absolute}"
        echo ""
        echo "          Please be sure this template is compatible with your browser!"
        echo "          If there is a mismatch data curruption extreamlly likely to occour!"
        echo ""
        echo "          If you do not answer within 60 seconds then we will not proceed."
        echo ""
        echo -n "       Would you like to continue and load this template? [y/N] : "
        proceed_with_unconfirmed_browser_identification=""
        timeout --foreground 60s read proceed_with_unconfirmed_browser_identification
        if \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "y" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "Y" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "yes" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "Yes" ]] && \
            [[ "${proceed_with_unconfirmed_browser_identification}" != "YES" ]] \
        ; then
            echo ""
            echo "          Tempalte loading aborted due to possibility of data curruption."
            echo "          This is due to possible selected browser and tempate mismatch!"
            echo ""
            exit -223
        fi
    fi
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Copying template data..."
    fi
    cp -r ${use_template_dir_absolute}/. ${browser_tmp_directory}/
    if [[ ${?} != 0 ]] ; then
        echo "ERROR! : Unable to copy template into place"
        exit -5
    fi
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Syncronizing filesystem..."
    fi
    sync
fi

# check if we are editing a template 
if [[ "${edit_template_dir_name}" != "" ]] ; then
    # saving the session details into the lock file
    echo "${screen_session_name}" > ${template_lock_file_absolute}
    if [[ ${?} != 0 ]] ; then
        echo "        WARNING! : Unable to save session details within the lock file."
    fi
    # temp directory is not used for this session (keeping the data and saving into the tempalte)
    user_data_directory="--user-data-dir=${edit_template_dir_absolute}"
    # create a sym-link within that directory to the template for clarity
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Linking to template data..."
    fi
    ln -s "${edit_template_dir_absolute}" ${browser_tmp_directory}/loaded_template.link 2>/dev/null
    if [[ ${?} != 0 ]] ; then
        echo "" ; echo "        WARNING! : Unable establish symlink within temporary directory to the template."
    fi
    if [[ "${creating_new_template}" == "true" ]] ; then
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
    if [[ "${quite_mode}" != "true" ]] ; then
        echo "        Syncronizing filesystem..."
    fi
    sync
else
    # standard usage # using the temp directory (delete when browser closes)
    user_data_directory="--user-data-dir=${browser_tmp_directory}"
fi

# are we running in standard mode
incognito_options="--incognito"
if [[ "${standard_mode}" == "true" ]] ; then 
    # not running incognito mode (eg standard mode)
    incognito_options=""
fi

# parse the arguments for options and URL's to pass to brave.
browser_options="${user_data_directory} ${incognito_options}"
url_list=""
while [[ ${#} -ge 1 ]] ; do
    # note, that no additional checking for validy of options is performed.
    # maybe in a future version of this script.
    if [[ $(echo "${1}" | grep -e "^-") ]] ; then
        browser_option_name=$(echo "${1}" | sed -n 's/.*--\([^=]*\)=.*/\1/p')
        browser_option_value=$(echo "${1}" | sed 's/^[^=]*=//')
        if [[ ${browser_option_name} != "" ]] && [[ ${browser_option_value} != "" ]] ; then
            new_browser_argument="--${browser_option_name}=\"${browser_option_value}\""
            browser_options="${browser_options} ${new_browser_argument}"
        else
            browser_options="${browser_options} ${1}"
        fi
    else
        if [[ "${1}" != "--edit_template_dir_name" ]] && [[ "${1}" != "--use_template_dir_name" ]] && [[ "${1}" != "${use_template_dir_name}" ]] &&  [[ "${1}" != "${edit_template_dir_name}" ]] ; then
            # build the URL list (but exclude the template and edit-tempate data which may be have been provided)
            url_list="${url_list} \"${1}\""
        fi
    fi
    shift
done


# start a screen session with the name based off the temp directory, then once browser exits delete the temporary directory
screen -S "${screen_session_name}" -dm bash -c " \"${spb_browser_path}\" ${browser_options} ${url_list} ; sleep 1 ; sync ; rm -rf ${browser_tmp_directory} ${spb_etlfr_cmd} "
exit 0
