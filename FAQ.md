# Frequenty Asked Questions

This document aims to provide clear ansers to some of the SPB frequently asked questions.

<br>
<br>

### Will SPB work with browsers other than Brave
Yes, SPB works fine with various web browsers. 

<hr>

  - More information about the SPB configuration file is available in the [README.md](https://github.com/henri/spb#spb-configuration-file) file.
  - Additional information regarding [SPB browser support](https://github.com/henri/spb/#sunrise-browser-support).

<hr>

#### Configure default browser as FireFox on MacOS within the SPB Configuration file

   - Run this command to start editing the SPB configuration file
       ```
         start-private-browser --edit-configuration
       ```
   - Add the following into that file to set FireFox as the default browser on macOS.
     
     Alter as required for your prefered browser and operating system preferneces.
       ```
       export spb_browser_name="firefox"
       export spb_browser_path=/"Applications/Firefox.app/Contents/MacOS/firefox"
       ```

