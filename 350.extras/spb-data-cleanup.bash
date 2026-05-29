#!/bin/bash
#
# custom directory
custom_spb_tmp=/path/to/your/custom/spb/tmp/path
#
# cleanup files older than one hour
cd ${custom_spb_tmp} 2>/dev/null || { echo "ERORR! : Unable to chnage directory to : ${custom_spb_tmp} " ; exit -99 ; }
for old_data_dir in $( find ./spb*-$(whoami)-* -maxdepth 0 -type d -mmin +60 2>/dev/null ) ; do
    echo ""
    rm -rf ${old_data_dir} 2>/dev/null || { echo "ERORR! : Unable to delete stale directory : ${old_data_dir}" ; exit -97 ; }
    echo "    removed : ${custom_spb_tmp}/${old_data_dir}"
done
if [[ $old_data_dir == "" ]] ; then
    echo ""
    echo "    no files were found to be cleaned up in the directory : ${custom_spb_tmp}"
    echo ""
fi
cd - >/dev/null 2>/dev/null || { echo "ERORR! : Unable to switch back to origional directory." ; exit -96 ; }
