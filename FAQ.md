# Frequenty Asked Questions

This document aims to provide clear ansers to some of the [SPB](https://github.com/henri/spb/blob/main/README_INDEX.md) frequently asked questions.

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

#### What is '[easy-as](https://github.com/henri/spb/blob/main/README.md#lock--spb-start-private-browser)'?
Easy-as is one of many classic kiwi expressions. [Kent](https://learntolanguage.com/about/) from [learn to language](https://learntolanguage.com/new-zealand-slang-101-your-guide-to-kiwi-expressions/)
puts it better than I ever could so there is a helpful quote of his wonderful writing skills below : 

>"Sweet as" and the use of "as"
>
>Perhaps the most iconic New Zealand phrase, "sweet as" is a versatile expression meaning "excellent" or "no problem."
>The "as" doesn't refer to anything specific ; it's just a grammatical quirk that Kiwis love that basically means "really" or "very".
>For example, "Everything's sweet as!" means everything is going great.
>
> Example:
> ````
>    Hey mate, I'll pop over around 2 pm. –  Sweet as!
>    I'm hungry as, I haven't eaten all day.
>    I'm tired as = I'm really tired
>  ````
Quoted from [learn to language](https://learntolanguage.com/new-zealand-slang-101-your-guide-to-kiwi-expressions/). Visiting this site to learn more New Zealand slang is highly reccomended ; if you want to hit the ground running (in terms of your understanding) when visiting New Zealand for the first time!

