
# :lock: <a href="https://github.com/henri/spb/#lock-spb-start-private-browser"> SPB (start-private-browser)
<!-- <img src="https://henri.github.io/spb/transparent_background_logo_fish.png" height="45" align="bottom"></a> -->

Have you wished there was an easy way to interact with the web from your terminal? Maybe like me you feel ready  to automate your web surfing from the tranquility of the shell? The bundled [SPB fish snippits](https://github.com/henri/spb/?tab=readme-ov-file#fish-shell-wrappers) makes searching for information from the fish shell easy-as! 


SPB presents the power to navigate the surging currents of our planets vast digital oceans right at your fingertips. SPB is a deceptivly simple shell [script](https://github.com/henri/spb/blob/main/050.start-private-browser.bash) which will rapidly spawn one or more isolated browser sessons. The [built-in SPB templating system](https://github.com/henri/spb/blob/main/README.md#spb-templating-support) allows isolation between different tasks.



<p align="center">
  <a href="https://github.com/henri/spb/blob/main/README_INDEX.md"><img src="https://henri.github.io/spb/spb-fish.png" width="90%"></a>
</p>

Swim happily ; SPB [installs](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) into your home directory (no need for sudo) and is [easily removed](https://github.com/henri/spb/?tab=readme-ov-file#bookmark_tabs-usage) in the event you don't make use of SPB each and every day. [This GitHub repository](https://github.com/henri/spb) has everything you need to [install and update](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) SPB on your systems.

[Harness the power](https://github.com/henri/spb/?tab=readme-ov-file#raising_hand-why-is-spb-needed) of isolated web sessions with SPB. Every time you run SPB a new instance of [Brave](https://brave.com/) (a modern web browser) or another browser (which you [specify](https://github.com/henri/spb/?tab=readme-ov-file#sunrise-browser-support)) is spawned within a fresh [screen](https://www.gnu.org/software/screen/) session. When you close the browser, [SPB will delete all <b>web</b> data related to that browser session](https://github.com/henri/spb?tab=readme-ov-file#shield-privacy) from your computer.

<br/>

<p align="center">
  <!-- <a href="https://https://www.gnu.org/licenses/gpl-3.0.en.html"><img src="http://img.shields.io/badge/License-GPLv3-red.svg"></a> -->
  <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/bash_script-%23121011.svg?logo=gnu-bash&logoColor=white"></a>
      <a href="https://github.com/henri/spb/blob/main/README.md"><img src="https://img.shields.io/badge/%2B-%23121011?logoColor=white"></a>
  <a href="https://curl.se/"><img src="https://img.shields.io/badge/curl-%23121011.svg?logo=curl&logoColor=white"></a>
      <a href="https://github.com/henri/spb/blob/main/README.md"><img src="https://img.shields.io/badge/%2B-%23121011?logoColor=white"></a>
  <a href="https://brave.com/"><img src="https://img.shields.io/badge/Brave-%23121011.svg?logo=Brave&logoColor=white"></a>
      <a href="https://github.com/henri/spb/blob/main/README.md"><img src="https://img.shields.io/badge/%2B-%23121011?logoColor=white"></a>
  <a href="https://www.gnu.org/software/screen/"><img src="https://img.shields.io/badge/GNU-screen-%23121011.svg?logo=terminal&logoColor=whhttps://github.com/henri/spb/blob/main/README.md#dart-spb-feature-summaryite"></a>
      <a href="https://github.com/henri/spb/blob/main/README.md"><img src="https://img.shields.io/badge/%2B-%23121011?logoColor=white"></a>
  <a href="https://kernel.org/"><img src="https://img.shields.io/badge/Linux-%23121011.svg?logo=linux&logoColor=white"></a>
      <a href="https://github.com/henri/spb/blob/main/README.md"><img src="https://img.shields.io/badge/%2B-%23121011?logoColor=white"></a>
   <a href="https://www.apple.com/macos"><img src="https://img.shields.io/badge/macOS-%23121011.svg"></a>
</p>
<br/>

This project is still in a [seedling stage](https://github.com/henri/spb/?tab=readme-ov-file#warning-disclaimer). If you find a bug please [start a discussion](https://github.com/henri/spb/discussions) or [open an issue](https://github.com/henri/spb/issues). SPB is [free software](https://www.gnu.org/philosophy/free-sw.en.html) (thank you [RMS](https://en.wikipedia.org/wiki/Richard_Stallman)) [released under the GNU GPL v3 or later](https://github.com/henri/spb#memo-licensing-terms-of-use-and-legal). If you enjoy using SPB, then share a link with your friends! This way you and your friends enjoy the [benifits](https://github.com/henri/spb/?tab=readme-ov-file#raising_hand-why-is-spb-needed) of SPB together! True friends protect their friends from data spills.

<br/>

SPB features built-in support for a growing list of [operating systems](https://github.com/henri/spb/blob/main/README.md#triangular_flag_on_post-compatibility) and [browsers](https://github.com/henri/spb/blob/main/README.md#sunrise-browser-support). SPB works from most interactive shells. However, keep in mind that development is focused on the fish shell.

<br/>

More than just software. This project also attempts to be an extensive reference for anyone interested in learning more about web browser basics ; in particular the focus of this projects documentaiton is related to privacy as it relates to web browsers.

<br/>

Looking for something specific. Check out the helpful [SPB Index](https://github.com/henri/spb/blob/main/README_INDEX.md).

<br/>


### :dart: SPB Feature Summary

  - [Create](https://github.com/henri/spb#bookmark_tabs-usage) multiple isolated web browser instances.
  - Reliable browser [templating](https://github.com/henri/spb#spb-templating-support) system
     - providing task isolation
     - browser customisation
     - isolated cookie storage
     - repeatable browser configuration
     - sharing of browser templates between systems
  - Support for [multiple web browsers](https://github.com/henri/spb#sunrise-browser-support)
  - Compatabilty with [many](https://github.com/henri/spb#triangular_flag_on_post-compatibility) operating systems
  - Stright forward [install](https://github.com/henri/spb#floppy_disk-installation), [update](https://github.com/henri/spb#bookmark_tabs-usage) and [removal](https://github.com/henri/spb#bookmark_tabs-usage) process
  - [Privacy](https://github.com/henri/spb#shield-telemetry-and-privacy) respecting
  - Extensive customisation options
      - conguration file
      - command line switches
      - enviroment varables
      - shell wrapper functions
        - support for starting [Tor](https://github.com/henri/spb?tab=readme-ov-file#fish-shell-wrappers) session
      - custom scripts
  - [Licensed](https://github.com/henri/spb#memo-licensing-terms-of-use-and-legal) under GNU GPL, ensuring your rights (as a user of this software) are respected.


<br>

### :floppy_disk: Installation 
  1. [Confirm your operating system is supported and install dependicies](https://github.com/henri/spb/blob/main/README.md#triangular_flag_on_post-compatibility)
  2. Kick-off install/upgrade by running following inside a BASH shell : 
```bash
/bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash)"
```
> <sub>Detailed install instructions : Copy and paste the lines above into a terminal and press enter. [View source code](https://github.com/henri/spb/blob/main/500.spb-install-script.bash)</sub>

> <sub>**Operating system specific installation instructions for SPB dependencies is [available below](https://github.com/henri/spb/blob/main/README.md#triangular_flag_on_post-compatibility).**</sub>

> <sub>Only run code from sources whom you [trust](https://github.com/henri/spb/?tab=readme-ov-file#lock-security-and-trust). Inspect SPB source-code [ [installer](https://github.com/henri/spb/blob/main/500.spb-install-script.bash), [project](https://github.com/henri/spb/blob/main/050.start-private-browser.bash) and [fish snippets](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8) ] below.</sub>

> <sub>The [installer/update](https://github.com/henri/spb/blob/main/500.spb-install-script.bash) script is a convenience to simplify installation and updating of spb on your system(s). Updates are semi-automatic because in order to update you manually run the [installer](https://github.com/henri/spb/blob/main/500.spb-install-script.bash) interactively. Check the [automated notes](https://github.com/henri/spb/?tab=readme-ov-file#arrows_counterclockwise-automate-installation-and-updates) for details on configuring unattended spb updates and installations. Also, before enabling automatic updtes read the [disclaimer section](https://github.com/henri/spb/?tab=readme-ov-file#warning-disclaimer) carfully. When installing SPB (using the above command), automatic updates are not enabled. If you want automatic updates, you must [deliberatly select](https://github.com/henri/spb/?tab=readme-ov-file#arrows_counterclockwise-automate-installation-and-updates) that as an option.</sub>

> <sub>If you prefer to use spb without using the install/update script (not recommended due to ease of using the install script ) ; just copy the SBP [project](https://github.com/henri/spb/blob/main/050.start-private-browser.bash) script to your system and make it executable.<sub>
<br/>

### :bookmark_tabs: Usage

Once [installation](https://github.com/henri/spb/?tab=readme-ov-fil/#floppy_disk-installation) is complete. The following commands will get you started with SPB.

---

Start a **new private browser** session : 
```bash
~/bin/start-private-browser.bash
```

Show SPB **help**  : 
```bash
~/bin/start-private-browser.bash --help | less -S
```
  
Manual SPB **Update** : 
```bash
~/bin/spb-update.bash
```
  
Update SPB **help** : 
```bash
~/bin/spb-update.bash --help | less -S
```

---

**Uninstall** SPB from your system :  

If you decide it is time to remove SPB and assosiated data

```bash
# removes spb software and any update logs
rm -ri ~/bin/start-private-browser.bash ~/bin/spb-update.bash ~/bin/spb-update.log

# remove your spb custom templates and configruation file ; assuming you have not saved to a custom location
# carful you may not want to delete this data - CAUTION ADVISED!
rm -ri ~/bin/spb-templates

# remove your spb fish functions ; including any custom spb functions
# carful you may not want to delete this data - CAUTION ADVISED!
rm -ri ~/.config/fish/functions/spb*.fish ~/.config/fish/functions/start-private-browser.fish
```
--- 
<br/>

### :star: Usage Examples
The real power of SPB is less about the basic usage listed above and more the ability to automate tasks using SPB wrapper scripts and functions. Get ready for SPB to make your life better each and every day.
  
Automatons which leverage SPB may be simple operations such as performing a search or starting a chat. They may be also be complex operations controlled by scripts which will assist you with performing testing, bench-marking and other steps which you may need to be able to carry out repeatedly.

Below are starter SPB examples for the fish shell to enhance every day web based tasks. More examples are on the horizon for testing, bench-marking, advanced automatons such as leveraging AI agents. If you have created something which you feel may be useful to the SPB community, [start a discussion](https://github.com/henri/spb/discussions) and share your ideas.

Handy wrapper scripts to facilitate SPB usage via the command line : 
> <sub>During [installation](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) if fish is installed, you will be prompted to automatically install these fish snippets. If you install fish after SPB and would like to install these snippets, just run the [update command](https://github.com/henri/spb/?tab=readme-ov-file#bookmark_tabs-usage) or [re-install](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation)</sub>
#### [fish shell wrappers](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8) 
If you are using the fish shell, then these commands should be active and ready for you to run. These commands will facilitate your exploration of the worlds vast digital oceans using the fish shell.

<sub> Click on the 'snippet name' links below in order to show usage information relating to a specific snippit</sub>
| command         | snippet name          | explanation |
| --------------- | --------------------- | ------------|
|  `spb`          |  [spb](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-fish) | an alias to start-private-browser<br>but shortedned to spb<br>overide with your favorite extras|
|  `spb-tor`      |  [spb-tor](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-tor-fishh) | start SPB with [Tor](https://www.torproject.org) network enabled ;<br>equivalent to spb --tor|
| `spb-smart`     |  [spb-smart](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-smart-fish) | experimental brave search / direct URL access |
| `spb-ddg`       |  [DuckDuckGo Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-ddg-fish)  |  start multiple DuckDuckGo searches |
| `spb-ddg-ai`    | [DuckDuckGo Chat](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-ddg-ai-fish) | have multiple DuckDuckGo AI (LLM) chats  |
| `spb-brave`     | [Brave Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-brave-fish) | start multiple Brave searches |
| `spb-brave-ai`  | [Brave Browser Leo Summary](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-brave-ai-fish) | begin multiple Brave AI (Leo) summerisations |
| `spb-yt`        |  [YouTube Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-yt-fish) | initiate simultaneous [YouTube](https://youtube.com) searches |
| `spb-rum`       |  [Rumble Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-rum-fish) | initiate simultaneous [Rumble](https://rumble.com) searches |
| `spb-bit`       |  [BitChute Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-bit-fish) | initiate simultaneous [BitChute](https://bitchute.com) searches |
| `spb-ody`       |  [Odysee Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-ody-fish) | initiate simultaneous [Odysee](https://odysee.com) searches |
| `spb-twitch`    |  [Twitch Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-twitch-fish) | initiate simultaneous [Twitch](https://twitch.tv) searches |
|  `spb-pai`      |  [Perplexity AI Chat](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-perlexity-ai-fish) | kick off conversations with Perplexity AI |
|  `spb-mist`     |  [Mistral AI Chat](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-mistral-ai-fish) | kick off conversations with Mistral AI |

  
> <sub>If your system has [fish](https://fishshell.com/) installed and you run the update system in an unattended mode, then these snippets will be installed / updated. This is because that is the default option. When running in unattended mode all default options are selected. If you do not want the above [snippets installed](https://github.com/henri/spb/?tab=readme-ov-file#file-spb-fish-function-installer-bash) please run the update script interactively and enter "no" when asked during the install process. Again the prompt for opting out is only available during interactive mode when using [spb-update.bash](https://github.com/henri/spb/blob/main/600.spb-update.bash) script or when manually running the [install/update](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) process.


<sub>The SPB project is <b>not</b> affiliated with any of the companies or the services listed above. Before using third party web services as listed above (eg Ai, Search, etc) it is recommended that you first consult the services usage and privacy policy. Many of these web based services offer a service in exchange for gathering and storing supplied information). Additional, examples like this are welcomed. If you put together something and would like to share a link to your work, [start a discussion](https://github.com/henri/spb/discussions) until, the pull request system for fish snippits is imporved.</sub>

#### SPB Templating Support

The built-in templating sub-system allows you to list, create, edit and load browser data templates. Essentially, this allows you to configure a browser just as you like and then load this template as needed for future browsing sessions. When you load an existing template a copy of the template is created for your session and then when you quit that copy is deleted. However, you still have the template and may start as many separate browser instances as you like form that template.

The templates are stored in the directory : ~/bin/spb-templates/

> **IMPORTANT NOTE** : <br>Using either "--new-template" or "--edit-template" options will result in data from<br>your websession being saved to your computer. This stored data enables access and<br>loading of the tempalte at a later time.
  
| example command                      | explanation    |
| ------------------------------| -------------- |
| `spb --new-template template-name` | Creates a new template and loads a browser within which you<br>may edit this newly created template.<br><br>Upon quit the template will be saved :floppy_disk: | 
| `spb --edit--template template-name`  | Edits the existing template and load a browser in<br>which you may edit the exiting template.<br><br>Upon quit the template will be updated :floppy_disk: | 
| `spb --template template-name` | Loads the existing template<br>within a new browser.<br><br>Upon quit all data from<br>the session is deleted.  |
| `spb --template template-name --standard` | Loads the specified template.<br>But will not start in incognito mode. |
| `spb --list-templates` | Presents a list of templates on your system. |
<br/>

Templates allow you to run browsers in a more standard browser mode but to still have isolated instances of a browser running simultaneously. To accomplish this simply create the new templates, then edit those templats. Effectively, you will be able to start separate browser instances but all data will be saved to that template (provided you use the --standard mode option combined with the --edit-tempalte option). When you exit the browser the data will *not* be deleted ; instead (like a typical browser session) data wil be saved :floppy_disk: because you are editing the template in standard mode.

<br>
<br>


### :shield: Privacy

SPB is a useful tool which is able to assist you in your privacy journey. Below are important links to sections of this documentation and external resources regarding SPB and your privacy. Like any tool, it is important to spend time learning the basics so you understand when and how it will assist you with your privacy, as well as the limitations.

Information availble via the links below will assist with forming a deeper understanding of SPB as a tool so you will know when to weild : 

  - [Disclaimer](https://github.com/henri/spb#warning-disclaimer) <sub>:star2: important things to understand</sub>
  - [Telemetry and Privacy](https://github.com/henri/spb#shield-telemetry-and-privacy)
  - [Templating Sub-System](https://github.com/henri/spb#spb-templating-support) <sub>:floppy_disk: web data is preserved in certian template modes</sub>
  - [Security and Trust](https://github.com/henri/spb#lock-security-and-trust)
  - [Brave Telemetry Issues](https://github.com/brave/brave-browser/issues/48604) <sub>:telephone: data sent to mothership by brave</sub>

<br>

Keep in mind that different browsers will potentially have different [options](https://github.com/henri/spb/blob/main/901.notes_browser_specific.md) which may alter the way the program works in terms of your privacy.

<br>
<br>


### :triangular_flag_on_post: Compatibility 
Mild testing has been completed on the following operating systems :
<p align="left">
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#triangular_flag_on_post-compatibility" ><img src="https://henri.github.io/spb/spb-compatability.png" width="30%"></a>
</p>

  > Each operating system section listed below provides instructions for installing SPB dependencies using the terminal. At present the SPB installer will not automatically install dependiencies. That is left to you. SPB will not work correctly without the dependecies installed on your system. Either use the instructions below for your operating system or install dependcies using your own prefered approach. If you have an operating system which is not listed below as long as you are able to install the dependcies then SPB will likely work just fine.

<sub>Once the SPB dependencies have been installed, [proceed with the installation of SPB](https://github.com/henri/spb/blob/main/README.md#floppy_disk-installation)</sub>

  - <b>GNU/LINUX</b>
      - [Linux Mint](https://www.linuxmint.com/)
        ```
          sudo apt-get update && apt-get install git fish coreutils gcp
          curl -fsS https://dl.brave.com/install.sh | sh
        ```
      - [Pop!_OS](https://system76.com/pop/)
        ```
          sudo apt-get update && apt-get install git fish coreutils gcp screen
          curl -fsS https://dl.brave.com/install.sh | sh
        ```
      - [Arch](https://archlinux.org/)
        ```
          sudo pacman -Syu git fish coreutils grep screen pv
          yay -S brave-bin
        ```
          - [CachyOS](https://cachyos.org/)
            ```
              sudo pacman -Syu screen
              paru -S brave-bin
            ```
          - [EndeavourOS](https://endeavouros.com/)
            ```
              sudo pacman -Syu git fish coreutils grep screen pv
              yay -S brave-bin
            ```
          - [Manjearo](https://manjaro.org/)
            ```
              sudo pacman -Syu git fish coreutils grep screen pv
              curl -fsS https://dl.brave.com/install.sh | sh
            ```
          - [Omarchy](https://omarchy.org/)
            ```
              sudo pacman -Syu git fish coreutils grep screen pv
              yay -S brave-bin
            ```
      - [Debian](https://www.debian.org/) (x86)
        ```
          sudo apt update
          sudo apt install apt-transport-https curl git fish coreutils grep screen pv
          sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
          echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
          sudo apt update
          sudo apt install brave-browser 
        ```  
  
   - <b>MacOS</b>
       - Brew or MacPorts are the recommend approaches to managing SPB dependencies on MacOS
           - MacOS pacakge managers 
               - [Brew](https://brew.sh)
                 ```
                   brew install git fish coreutils pv bash
                   brew install --cask brave-browser
                 ```
               - [MacPorts](https://www.macports.org/)
                   - ``` sudo port install git fish coreutils pv bash```
                   - Visit the [Brave website](https://brave.com/download/) and to manually install.
       - macOS 10.15 (and later)
       - Officially the latest versions of Chromium [requires macOS 13](https://issues.chromium.org/issues/376381582) or later.
  
<br/>

  > If you have managed to get SPB working on your operating system and your operatiing system is not listed above, kindly consider contributing a pull request which includes instructions ; in order to assist others with getting up and running quickly.
<br/>

### :shield: Telemetry and Privacy
As you would expect. The SPB project has zero telemetry. As such if you decide to install and use this software nothing is sent back to mother-ship. 

Most shells are configured by default to save a history of commands. As such, if you are including URL's, search terms or other data as arguments to SPB, then be aware these will potentially be stored on your system. Removing hisotry data from a shell is often possible (but beyond the scope of this documentation). If you are using the fish shell, you may start a private fish session using the '--private' option (example below) and within these private fish sessions the history will not perisist on your system once you exit the shell. 
```
fish --private
```

Some terminals / operating systems / kernel modules / system extensions / shell extensions / malware may send data from your machine to remote systems! It is important to understand the layers of the software stack and what is being sent and also what may be anylysed locally on your systems. 

If you require no trace left behind on your device as you browse the web, then [SPB is likely not the right tool](https://github.com/henri/spb/blob/main/README.md#warning-disclaimer). 

  > Note : If you schedule or manually run an install / update, then your system will poll and potentially access this Github reposotry. As such, it is advisable that you read the section below regarding this project being hosted on GitHub. If this is a problem think twice before installing SPB or running SPB updates (manually / scheduled).

SPB is hosted on GitHub :octocat: and as such data is recorded :record_button: as you access this page. At the bottom of this page you will find links to manage the way GitHub handles your data and tracking within a browser. Also, the following links are useful with regards understanding the stance of GitHub towards privacy and trust : 

  - [GitHub Trust Center : Privacy](https://github.com/trust-center/privacy)
  - [GitHub Site Policy : Privacy](https://docs.github.com/en/site-policy/privacy-policies)

When automatically or manually running the install / update commands, data from your system is sent to GitHub infrastructure so that SPB is able to be installed / updated on your system. If this is a problem in your environment, it is suggested that you [roll your own](ttps://github.com/henri/spb/?tab=readme-ov-file#roll-your-own) update system.

As the default browser option in SPB is [Brave](https://brave.com/) and that project is a telemetry sender ; it is advisable that you read the Brave [privacy policy](https://brave.com/privacy/browser/). Brave is an [open source project](https://github.com/brave/brave-browser). However, if having any kind of telemetry being sent out is a problem then you should opt to use a different browser. Also, follow and chime into [this issue on github](https://github.com/brave/brave-browser/issues/48604) with your opinion(s) regarding telemetry opt-out features within Brave. 

<p align="center">
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#shield-telemetry-and-privacy" ><img src="https://henri.github.io/spb/spb-telemetry-privacy.png" width="60%"></a>
</p>
  
Different operating systems and even different LINUX distributions have different stances on privacy and telemetry. As such it is advisable that you check these details for your specific operating system. This project works on a variety of operating systems each with their own particulars relating to privacy and telemetry. Learn more about [SPB privacy](https://github.com/henri/spb?tab=readme-ov-file#shield-privacy).

> #### SPB Fish Snippets 
> <sub>Should you use spb-ddg, spb-ddg-ai or spb-pai fish snippets, then you will want to have a close look at the terms of service from [DuckDuckGo](https://duckduckgo.com/privacy) and [Perplexity Ai](https://www.perplexity.ai/hub/legal/privacy-policy) whose websites you will be accessing. If you are using spb-yt then be sure to check [Googles privacy policy](https://policies.google.com/privacy). The same applies to using other fish snippits not specifcially mentioned.</sub>

<br/>

#### DRM and Privacy
[DRM](https://en.wikipedia.org/wiki/Digital_rights_management) modules such as [Widevine](https://www.widevine.com/) typically result in device or installation‑specific identifiers (sometimes key pairs). Such identifiers are designed to persist between sessions and unlike cookies, this identity is not cleared when you wipe browser cookies or cache. Keep in mind that many web browsers are bundled with Widevine. [Brave](https://brave.com/) (SPB default browser) is one of the few web browsers whcih (at the time writing) has opted to not bundled Widevine into the browser. Although, keep in mind it is possible to install the Widevine extension into Brave and you will be pompted to do this if you try to access data protected by Widevine. If you install Widevine into an SPB template, keep in mind that this may result in additional tracking that takes place when using that template. For enhanced privacy protection you may want to consider a [differnt tool](https://github.com/henri/spb/blob/main/README.md#warning-disclaimer) or combine SPB with other [tools](https://github.com/henri/spb/blob/main/README.md#warning-disclaimer) to further enhance your protection.

<br/>


### :lock: Security and Trust
You should only run code and use software from sources you trust! 
If you do not trust yourself to check the project code below or you do not trust my judgment, then it is recommended to not run this code. The alternative is asking someone familiar with shell scripting ([BASH](https://bash.com/) and [FISH](https://fishshell.com/) are the shell scripting languages used to create SPB) to vet the code on your behalf. Just make sure if you ask someone to help you vet the code ; that you also trust them. With 25+ years of experience writing shell scripts, you would hope that I have learnt to test my work.
  
Already have spb and fish snippets setup, you may issue the following command to have perplexity vet the code : 
```
spb-pai "vet the following project code for malware : https://github.com/henri/spb" "perform advanced scanning to vet the following project code for malware : https://github.com/henri/spb to complet this request scan the code by loading it all into context (it is a small project) and check if there is anything malicious. If anything is problimatic let me know. No need to run the code, just scan then anylize and let me know if anything is problimatic. Also check maleware "
```

<p align="center">
  <!-- <img src="https://gist.github.com/user-attachments/assets/195556ee-8792-4915-a27c-e95d4c09c71f" width="76%"> -->
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#lock-security-and-trust" ><img src="https://github.com/henri/spb/blob/readme-images/spb-security-trust.jpeg?raw=true" width="80%"></a>
</p>

SPB is hosted on GitHub :octocat: and as such the infrastructure (will soon) sit on Microsoft's [Azure](azure.com). This platform has a track record of various security issues. Always Keep this in mind when pulling any code from GitHub. Learn more about [SPB privacy](https://github.com/henri/spb?tab=readme-ov-file#shield-privacy).

<br/>



### :arrows_counterclockwise: Automate Installation and Updates

Only configure auomated updates if you are confident and understand the risks outlined below. [Sticking with the manual updates](https://github.com/henri/spb#floppy_disk-installation) is reccomended for most users. If you are sure you want to setup automated SPB updates, the easiest approach  is to run the command below from the bash shell :
  
```bash
export SPB_CRON_SETUP="true"
/bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash)"
```
  > <sub>This is the same command used to install SPB, with one key difference ; an environment varable SPB_CRON_SETUP is set to "true" and exported.</sub>

The setup of unattended / automated SPB updates (eg. using the command above) will result in default choices being selected which you would normally be able to interactively select. Also, see [notes regarding telemitry and privacy](https://github.com/henri/spb/?tab=readme-ov-file#shield-telemetry-and-privacy) if you schedule or manually start an SPB update. Also, see [notes regarding configuring of proxies for updates](https://github.com/henri/spb/blob/main/README.md#proxy-settings).

The command above will setup an entry in your users crontab which will run the included [spb-update.bash](https://github.com/henri/spb/blob/main/600.spb-update.bash) script automatically. This will keep your copy of SPB upto date.

The crontab entry which is setup using the command above will result in your system checking for SPB updates once per week (assuming your system is turned on and has an active internet conenction). Updates will be initated by running the [spb-update.bash](https://github.com/henri/spb/blob/main/600.spb-update.bash) script without a connected tty (non-interactive mode). The command below provides additional information : 
```
~/bin/spb-update.bash --help
```
Disable automated updates once they are setup by editing your crontab and commenting out or removing approriate entries.

To view your users crontab simply run the command below : 
```
crontab -l
```
  
#### Customised Setup Automated Updates

Keep in mind that to keep SPB upto date, you do not need to setup any kind of automation. This update script may be run interactively (see [usage above](https://github.com/henri/spb/?tab=readme-ov-file#bookmark_tabs-usage)) at any time. You may also prefer to start it via a scheduling program of your choice so that SPB regularly updates automatically at times which you prefer.

#### Start Unattended Updates (picks default choices)
Start an automated (unattended) update and monitor the progress by running the command below within a shell : 
```
  ~/bin/spb-update.bash --auto-monitoring
```
> <sub> Once the output stream completes (using the command above), press control-c to exit tail and return to your shell.</sub>

#### Roll Your Own
If you are looking to roll your own update system, then the notes below will assist you :
  - Pick a scheduling system (cron, launchd etc..) and add an entry
    - ensure that you export the following environment variables (examples for fish and bash are below) :
      - The example [update script](https://github.com/henri/spb/blob/main/600.spb-update.bash) is written in bash and includes these exported environment varables already.
        - fish
          - ```set --export SPB_SKIP_OVERWRITE_CHECK "true"```
          - ```set --export SPB_UPDATE_SCRIPT_SKIP="true"```
        - bash
          - ``` export SPB_SKIP_OVERWRITE_CHECK="true"```
          - ``` export SPB_UPDATE_SCRIPT_SKIP="true"```
        - You should also use a lock file to avoid more than one update running simultaneously
          - The lock file which is used by the update script is : 
            ```/tmp/spb-update-$(hostname)-$(whoami).lock```
    - Use the [kick off script](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) above to start the install / update. 
  
All of the above and much more is handled for you if you use the included [update script](https://github.com/henri/spb/blob/main/600.spb-update.bash). 

#### Proxy Settings
Using a single proxy, multiple proxies or even proxy chains allow you to have one or more intermediate systems between the site you access with your browser and that server providing the data or service.

If you export proxy environment variables (as shown below) then the SPB install / update scripts will respect these settings and perform network operations via the specified proxy.

```
  # proxy settings for SPB install / update scripts
  
  # bash 
  export http_proxy="http://proxy.server:port"
  export https_proxy="https://proxy.server:port"
  
  # fish 
  set -x http_proxy "http://proxy.server:port"
  set -x export https_proxy "https://proxy.server:port"
  
```
If you would like to use a proxy when checking for updates, it is reccomded that you either add the enviroment varables to your crontab (or automation system of choice) or create a custom update wrapper script which adds the proxy varables to your enviroment so they are respected during the update process. Editing the included update script should be avoided because during the update proces any changes made to that file will be removed.


<br/>

### :memo: Licensing, Terms of Use and Legal
SPB is released under the [GNU GPL 3 or later](https://www.gnu.org/licenses/gpl-3.0.html). The GNU GPL is a free software licence which [protects users freedoms](https://www.gnu.org/philosophy/free-sw.en.html). Learn more about [escaping to freedom](https://www.fsf.org/blogs/rms/20140407-geneva-tedx-talk-free-software-free-society). 

<br/>

### :raising_hand: Why is SPB needed? 

The use cases for this script are immense and include [simplified day-to-day web browsing](https://github.com/henri/spb/?tab=readme-ov-file#star-usage-examples), trouble-shooting, testing, load-testing, AI Agents performing multiple tasks or just having multiple tabs which are not related in terms of cookies etc. 

When starting a private session within the [Safari WebBrowser](https://en.wikipedia.org/wiki/Safari_(web_browser)) on [MacOS](https://en.wikipedia.org/wiki/MacOS) each tab is seperate (the cookies are not shared between tabs). However, most other browsers share the private cookies with all private tabs. One approach is not better or worse. But if you would like to have multiple instances of a browser but not have them sharing all those dirty cookies, then this script allows you to start up as many private (and separate) sessions as you need (as long as your system will cope with the additional system resources being used). Have fun loading some private browsers.

May the privacy be with you!

:shipit:

---

<p align="center">
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#raising_hand-why-is-spb-needed"><img src="https://henri.github.io/spb/spb-may-the-pricacy-be-with-you.png"></a>
</p>

--- 

<br/>

### :warning: Disclaimer
SPB (start private browser) is able to start multiple private browsers. But do not expect more functionality or privacy from running a browser in incognito mode. The idea behind SPB is that you can load multiple instances which are somewhat separated from one and other. Each instance is still running under your user account and on your system.

SPB [removes the web browser data from disk](https://github.com/henri/spb#spb-templating-support). However, SPB makes no effort to deal with data stored in memory such as file system caches or system memory which may have been [written to swap](https://en.wikipedia.org/wiki/Memory_paging).

In the event additional privacy is required run SPB within a VM or within a container. If higher levels of privacy are needed, then consider these projects :

  * [Tails](https://tails.net/)
  * [Whonix](https://www.whonix.org/)
  * [Cubes OS](https://www.qubes-os.org/)
  * [Kasm Workspaces](https://kasmweb.com/)
  * [Tor](https://www.torproject.org/)
    * [Brave Browser](https://brave.com/) features a built in Tor client and [Snowflake](https://support.brave.app/hc/en-us/articles/9059440641421-What-is-the-Snowflake-extension) extension

Is this list incomplete? If you know of a privacy focused system missing from this list [let me know](https://github.com/henri/spb/discussions).

If you test SPB and it works on your operating system [leave a comment](https://github.com/henri/spb/discussions) :) or let me know it is not working.
Currently there are no plans to make this work on Microsoft Windows. It may work within the WLS? Give it a try and let me know!
  
If you decide to setup a [scheduled automatic update](https://github.com/henri/spb#arrows_counterclockwise-automate-installation-and-updates), then you should trust that I am not going to add any malicious code into this system in the future and that the security of my systems are good enough to prevent someone else pushing malware into the code base. This applies to any software (not just SPB) which automatically updates (even if it is open source). You must alwasy trust the developers sufficiently if you enable auto-updates. This is why by design SPB will not automatically enable auto-updates. SPB expects that if you enable automatic updates you are intentionally placing trust in me to not mess with your system(s) deliberately and that I will secure my systems as the developer sufficiently to protect the SPB code base and build processes less, someone breaks my security in order to take advantage of yours. Remember that any software system which automatically updates via the internet has these same risks.

This project is still in the :seedling: seedling stage (with lots of potential). If you have suggestions / ideas to improve the way it works, then please [start a discussion](https://github.com/henri/spb/discussions). If you test this on a particular operating system and it works or is not working for you please also leave a comment so that others know to give it a try or not :)

Learn more about [SPB privacy](https://github.com/henri/spb?tab=readme-ov-file#shield-privacy).

<br/>

### :sunrise: Browser Support
SPB supports various browsers accross a wide range of operating systems. 

At startup SPB checks if BASH 4 or later is installed. If a modern version of BASH is detected, then multi-browser support is automatically enabled. SPB multi-browser support makes it possible to specify the browser name you would like to use via a command line option or from within the SPB configuration file. 

The example command showen below instructs SPB to load the Chromium rather than the Brave (the default) : 
```
spb --browser chromium
```

This next example will show a list of browsers which SPB nativly supports
```
spb --list-browsers
```

The path (or command) which will be used is launch the specified web browser is configured automatically within SPB for various operating systems. Pull requests are always welcome in this regard as there are so many different LINUX distributions with different apparoches to browser naming.

In the event you would like to try use a browser or operating system which is not officially supported, then you could try the following command to say launch chromium :

```
spb --browser chromium --browser-path chromium
```
Specifing the --browser and --browser-path command line arguments also allow you to reference non-standard paths or even setup browsers with custom icons for that session. These command line options allow you to quickly specify specific browsers on an adhoc basis.

It is also possible to configure a default browser name and path by adding the following lines into your SPB configuration file : 
```
export spb_browser_name="chromium"
export spb_browser_path="chromium"
```
This approach allows you to use try a browser which may not be officially supported on your operating system yet by SPB. In the example above we are selecting Chromium as the default browser for SPB.

In addition, it is possible to overide and/or extend the mutli-browser support options on your system within the spb.config file. If the spb.cofnig file present, SPB will source this file and many variables are able to be overriden and/or extended beyond the defaults which SPB multi-browser support nativly offers.

For additional information regarding SPB configuration files. Run the following command to open the SPB help page and jump to the appropriate section : 

```
spb --help | less -S -p "Configuration File"
```

#### SPB Browser Support History

SPB (Start Private Browser) was initially developed to only support and work with Brave (back then SPB was a much simpler system totaling less than 100 lines of code). Due to Brave being based on [Chromium](https://www.chromium.org) it was not a big task to update SPB to include support for Chromium and many other Chromium based browsers. With [Mozzila FireFox](https://www.firefox.com) also being an extreamlly popular browser having decent command line support, the more recent versions of SPB have experimenal support for FireFox and some FireFox forks. Currently, SPB includes multi-browser support for the following FireFox forks : 

  - [PaleMoon](https://www.palemoon.org/)
  - [Zen](https://zen-browser.app/)

Please note, that not all Chromium and FireFox based browsers are officially supported by SPB. Many broswers have significant variations from their upstream projects and in some cases these changes makes it impossible or at least difficult to get them working correctly with SPB ; without additional support from those projects. If you are a developer, then patches and pull requests are welcome if your faviorte browser is not yet supported and you would like to see support in an official SPB release. If you are not ready to make the changes yourself, then open an issue or start a discussion outlining your problem or request.

### :rocket: Contributing to the project
In order to protect users of this project all contributors must comply with the [Developer Certificate of Origin](https://developercertificate.org). This ensures that all contributions are properly licensed and attributed.

<br/>

### :earth_asia: External Resources

**Development / Testing / Automation**
  - [The Pi Guy : Chromium Command Line Tools](https://the-pi-guy.com/blog/chromiums_commandline_tools_and_scripts/)


**General**
  - [Brave : Using Command Line Switches](https://support.brave.com/hc/en-us/articles/360044860011-How-Do-I-Use-Command-Line-Flags-in-Brave)
  - [Brave : Cheatsheet](https://gist.github.com/henri/a454bb27edb3d3a567c5a695f0582aa7) (my gist)

<br/>
<br/>

<p align="center">
  <a href="https://github.com/henri/spb/"><img src="https://henri.github.io/spb/SPB_logo_with_text_with_boarder_tranparent_v1.png" width="30%"></a>
</p>

<br/>
