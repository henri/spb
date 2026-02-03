# Frequenty Asked Questions

This document aims to provide clear ansers to some of the SPB frequently asked questions.

<p align="left">
  <a href="https://github.com/henri/spb/blob/main/README_INDEX.md"><img src="https://github.com/henri/spb/blob/gh-pages/SPB_logo_with_text_with_boarder_tranparent_faq_v1.png" width="50%"></a>
</p>

### Will SPB work with browsers other than Brave
Yes, SPB works fine with various web browsers. 

<hr>

  - More information about the SPB configuration file is available in the [README.md](https://github.com/henri/spb#spb-configuration-file) file.
  - Additional information regarding [SPB browser support](https://github.com/henri/spb/#sunrise-browser-support).

<hr>

#### List Browsers Which SPB Nativly Supports
```
start-private-browser --list-browsers
```

<hr>

#### Start SPB Isolated Session using FireFox
```
start-private-browser --browser firefox
```

<hr>

#### Configure default browser as FireFox on MacOS within the SPB Configuration file

   - Run this command to start editing the SPB configuration file
       ```
         start-private-browser --edit-configuration
       ```
   - Add the following into that file to set FireFox as the default browser on macOS.
     
     Alter as required for your prefered browser and operating system preference.
       ```
       export spb_browser_name="firefox"
       export spb_browser_path=/"Applications/Firefox.app/Contents/MacOS/firefox"
       ```

