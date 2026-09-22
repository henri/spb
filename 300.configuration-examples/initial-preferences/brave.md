Configuring System Wide Initial Brave Browser Tab Settings (LINUX)

<hr>

```bash
# This example will set all ***new*** brave (and brave origin) instances to
# pull in these initial settings.

# This approach makes use of a initial_preferences file to alter default
# brave settings. This option is able to overridden by user by editing
# browser settings.

# Updating the binary name for your distribution may be required
# This example will work with certain installation methods and
# may need alterations depending on your particular install approach.

# This example configures a number of tab options.
# Replace with your desired initial preferences.
# At the time of writing brave has no support for
# passing this file in as a file on the CLI
# perhaps that feature will be added in a
# future update.

brave_install_dir=$(dirname $(realpath $(which brave-browser)))
if [ ! -e ${brave_install_dir} ] || [[ "${brave_install_dir}" == "" ]] ; then
echo "ERROR! Unable to locate brave install directory : ${brave_install_dir}" ; exit -7
fi

if ! [[ -e ${brave_install_dir}/initial_preferences ]] ; then
sudo tee ${brave_install_dir}/initial_preferences > /dev/null << 'EOF'
{
  "brave": {
    "tabs": {
      "vertical_tabs_enabled": true,
      "vertical_tabs_collapsed": true,
      "vertical_tabs_hide_completely_when_collapsed": true,
      "vertical_tabs_floating_enabled": true,
      "vertical_tabs_expanded_state_per_window": false
    }
  }
}
EOF
else
echo "ERROR! : you already have an initial_preferences file!" ; exit -9
fi

```

<hr>
