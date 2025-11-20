# thif file contains snippits of code to assist with debugging SPB and SPB components.

# # check if the screen session is running
# if [[ "${verbose_mode}" == "true" ]] ; then
#     sleep 10
#     if screen -ls | grep -q "${screen_session_name}" ; then
#         exit 0
#     else
#       echo ""
#       echo "ERROR! : Failed to start private browser session!"
#       echo ""
#       echo "You could try to manually start the browser :"
#       echo "mkdir ${browser_tmp_directory} && \"${spb_browser_path}\" ${browser_options} ${url_list}"
#       exit -55
#     fi
# fi
