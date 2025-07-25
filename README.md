# :lock: SPB (start-private-browser)

Have you wished there was an easy way to interact with the web from your terminal? Maybe like me you feel ready  to automate your web surfing from the tranquility of the shell? The bundled [SPB fish snippits](https://github.com/henri/spb/?tab=readme-ov-file#fish-shell-wrappers) makes searching for information from the fish shell easy-as! 

SPB presents the power to navigate the surging currents of our planets vast digital oceans right at your fingertips. SPB is a deceptivly simple shell [script](https://github.com/henri/spb/blob/main/050.start-private-browser.bash) which will rapidly spawn one or more isolated browser sessons. 

<p align="center">
  <a href="https://github.com/henri/spb/#lock-spb-start-private-browser"><img src="https://github.com/henri/spb/blob/readme-images/spb-fish.png?raw=true" width="90%"></a>
</p>

Swim happily ; SPB [installs](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) into your home directory (no need for sudo) and is [easily removed](https://github.com/henri/spb/?tab=readme-ov-file#bookmark_tabs-usage) in the event you don't make use of SPB each and every day. [This GitHub repository](https://github.com/henri/spb) has everything you need to [install and update](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) SPB on your systems.

[Harness the power](https://github.com/henri/spb/?tab=readme-ov-file#raising_hand-why-is-spb-needed) of isolated web sessions with SPB. Every time you run SPB a new instance of [Brave](https://brave.com/) (a modern web browser) is spawned within a fresh [screen](https://www.gnu.org/software/screen/) session. When you close the browser, SPB will delete all <b>web</b> data related to that browser session from your computer. 

This project is still in a [seedling stage](https://github.com/henri/spb/?tab=readme-ov-file#warning-disclaimer). If you find a bug please [start a discussion](https://github.com/henri/henri/discussions/categories/spb) or open an issue. SPB is free software, if you enjoy using SPB then share a link with friends. This way you and your friends enjoy the [benifits](https://github.com/henri/spb/?tab=readme-ov-file#raising_hand-why-is-spb-needed) of SPB together!

### :floppy_disk: Installation 
Kick-off install/upgrade by running the ~~one liner~~ four lines below in your terminal : 
```bash
/bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash)"
```
> <sub>Detailed install instructions : Copy and paste the lines above into a terminal and press enter.</sub>

> <sub>Only run code from sources whom you [trust](https://github.com/henri/spb/?tab=readme-ov-file#lock-security-and-trust). Inspect SPB source-code [ [installer](./34f5452525ddc3727bb66729114ca8b4#file-500-spb-install-script-bash), [project](./34f5452525ddc3727bb66729114ca8b4#file-050-start-private-browser-bash) and [fish snippits](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8) ] below.</sub>

> <sub>The [installer/update](https://github.com/henri/spb/blob/main/500.spb-install-script.bash) script is a convienince to simplify installation and updating of spb on your system(s). Updates are semi-automatic because in order to update you manually run the [installer](https://github.com/henri/spb/blob/main/500.spb-install-script.bash) interactivly. Check the [automated notes](https://github.com/henri/spb/?tab=readme-ov-file#arrows_counterclockwise-automate-installation-and-updates) for details on configuring unattended spb updates and installations. Also, before enabling automatic updtes read the [disclaimer section](https://github.com/henri/spb/?tab=readme-ov-file#warning-disclaimer) carfully.</sub>

> <sub>If you prefer to use spb without using the install/update script (not reccomdned) ; copy the SBP [project](https://github.com/henri/spb/blob/main/050.start-private-browser.bash) script to your system and make it executable.<sub>
  
### :bookmark_tabs: Usage

Once installation is complete. The following commands will get you started with SPB.

Start a **new private browser** session : 
```bash
~/bin/start-private-browser.bash
```

Show SPB **help**  : 
```bash
~/bin/start-private-browser.bash --help | less
```
  
**Update** SPB : 
```bash
~/bin/spb-update.bash
```
  
Update SPB **help** : 
```bash
~/bin/spb-update.bash --help | less
```

**Uninstall** SPB from your system : 
```bash
rm -ri ~/bin/start-private-browser.bash ~/bin/spb-update.bash ~/bin/spb-update.log ~/bin/spb-templates
```

### :star: Usage Examples
The real power of SPB is not so much with the basic usage listed above but with the abillity to create wrapper scripts or even simple functions which leverege SPB to perform specific operations automatically on your behalf. 
  
Automations which leverage SPB may be something simple like performing a search, starting a chat. They may be more complex operatons controlled by scripts which will assist you with performing testing, benchmarking or any other series of steps which you need to be able to carry out more than once.

Below are examples to get you started with SPB to enhance every day web based tasks. More examples are to come which will provide expamples for testing, benchmarking, more advanced automations and leveraging AI agents. If you have created something which you feel may be useful to the SPB communitiy, [start a discussion](https://github.com/henri/henri/discussions/categories/spb).

Handy wrapper scripts to facilitate SPB usage via the command line : 
> <sub>During [installation](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) if fish is installed, you will be prompted to automatically install these fish snippits. If you install fish after SPB and would like to install these snippits, just run the [update command](https://github.com/henri/spb/?tab=readme-ov-file#bookmark_tabs-usage) or [re-install](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation)</sub>
#### [fish shell wrappers](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8) 
<sub> Click on the 'snippit name' links below in order to show usage information relating to a specific snippit</sub>
| command         | snippit name          | explanation |
| --------------- | --------------------- | ------------|
|  `spb`          |  [spb](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-fish) | an alias to start-private-browser<br>but shortedned to spb |
|  `spb-tor`      |  [spb-tor](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-tor-fishh) | start SPB with [Tor](https://www.torproject.org) network enabled ;<br>equivilent to spb --tor|
| `spb-ddg`       |  [DuckDuckGo Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-ddg-fish)  |  start multiple DuckDuckGo searches |
| `spb-ddg-ai`    | [DuckDuckGo Chat](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-ddg-ai-fish) | have multiple DuckDuckGo AI (LLM) chats  |
| `spb-brave`     | [Brave Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-brave-fish) | start multiple Brave searches |
| `spb-brave-ai`  | [Brave Browser Leo Summary](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-brave-ai-fish) | begin multiple Brave AI (Leo) summerisations |
| `spb-yt`        |  [YouTube Search](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-yt-fish) | initate simultanius YouTube searches |
|  `spb-pai`      |  [Perplexity AI Chat](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-perlexity-ai-fish) | kick off converstations with Perplexity AI |
  
> <sub>If your system has [fish](https://fishshell.com/) installed and you run the update system in an unattended mode, then these snippits will be installed / updated. This is because that is the default option. When running in unattended mode all default options are selected. If you do not want the above [snippits installed](https://github.com/henri/spb/?tab=readme-ov-file#file-spb-fish-function-installer-bash) please run the update script interactivly and enter "no" when asked during the install process. Aagain the prompt for opting out is only available during interative mode when using [spb-update.bash](https://github.com/henri/spb/blob/main/600.spb-update.bash) script or when manually running the [install/update](https://github.com/henri/spb/?tab=readme-ov-file#floppy_disk-installation) process.


<sub>The SPB project is <b>not</b> affiliated with any of the companies or the services listed above. Before using third party web services as listed above (eg Ai, Search, etc) it is reccomended that you first consult the services usage and privay policy. Many of these web based services offer a service in exchange for gathering and storing supplied information). Additional, examples like this are welcomed. If you put together something and would like, share a link to your work then comment below or [start a discussion](https://github.com/henri/henri/discussions/categories/spb)</sub>

#### SPB Templating Support
The built-in templating sub-system allows you to list, create, edit and load browser data templates. Essentially, this allows you to configure a browser just as you like and then load this template as needed for future browsing sessions. When you load an existing template a copy of the template is created for your session and then when you quit that copy is deleted. However, you still have the template and may start as many sepeate browser instances as you like form that template.

The templates are stored in the directory : ~/bin/spb-templates/
  
| example command                      | explanation    |
| ------------------------------| -------------- |
| `spb --new-template template-name` | Creates a new template and loads a browser within which you<br>may edit this newley created template.<br><br>Upon quit the template will be saved  | 
| `spb --edit--template template-name`  | Edits the existing template and load a browser in<br>which you may edit the exiting template.<br><br>Upon quit the template will be updated  | 
| `spb --template template-name` | Loads the existing template<br>within a new browser.<br><br>Upon quit all data from<br>the session is deleted.  |
| `spb --template template-name --standard` | Loads the specififed template.<br>But will not start in incogneto mode. |
| `spb --list-tempaltes` | Presents a list of templates on your system. |


  
### :triangular_flag_on_post: Compatiability 
Mild testing has been completed on the following operating systems : 
<p align="left">
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#triangular_flag_on_post-compatiability" ><img src="https://github.com/henri/spb/blob/readme-images/spb-compatability.png?raw=true" width="30%"></a>
</p>
  
  - <b>GNU/LINUX</b>
      - Linux Mint
          - ``` apt-get update && apt-get install git fish coreutils ```
          - ``` curl -fsS https://dl.brave.com/install.sh | sh ```
      - EndeavourOS
          - ``` sudo pacman -Syu git fish coreutils grep ```
          - ``` yay -S brave-bin ```
  
   - <b>MacOS</b>
       - Brew or MacPorts are the reccomedned approaches to managing SPB dependencies on MacOS
           - MacOS pacakge managers 
               - [Brew](https://brew.sh)
                   - ```brew install git fish coreutils```
                   - ```brew install --cask brave-browser```
               - [MacPorts](https://www.macports.org/)
                   - ```sudo port install git fish coreutils```
                   - Visit the [Brave website](https://brave.com/download/) and to manually install.
       - macOS 10.15 (and later)
       - Officially the latest versions of Chromium [requires macOS 13](https://issues.chromium.org/issues/376381582) or later.
  
  
### :shield: Telemetry and Privacy
As you would expect. The SPB project has zero telemetry. As such if you decide to install and use this software nothing is sent back to mothership. 
  
  > Note : If you schdule or manually run an install / update, then your system will poll and potentailly access this Github gist. As such, it is advisable that you read the section below regarding this project being hosted on GitHub. If this is a problem think twice before installing SPB or running SPB updates (manually / scheduled).

SPB is hosted on GitHub :octocat: and as such data is recorded :record_button: as you access this page. At the bottom of this page you will find links to manage the way GitHub handles your data and tracking within a browser. Also, the following links are useful with regards understanding the stance of GitHub towards privacy and trust : 

  - [GitHub Trust Center : Privacy](https://github.com/trust-center/privacy)
  - [GitHub Site Policy : Privacy](https://docs.github.com/en/site-policy/privacy-policies)

When automatiaclly or manually running the install / update commands, data from your system is sent to GitHub infrasturcture so that SPB is able to be installed / updated on your system. If this is a problem in your enviroment, it is suggested that you [roll your own](ttps://github.com/henri/spb/?tab=readme-ov-file#roll-your-own) update system.

As the default browser option in SPB is [Brave](https://brave.com/) and that project is a telemetry sender ; it is advisable that you read the Brave [privacy policy](https://brave.com/privacy/browser/). Brave is an [open source project](https://github.com/brave/brave-browser). However, if having any kind of telemetry being sent out is a problem then you should opt to use a different browser. Also, follow and chime into [this issue on github](https://github.com/brave/brave-browser/issues/40799) with your opinion(s) regarding telemetry opt-out features within Brave. 

<p align="center">
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#shield-telemetry-and-privacy" ><img src="https://github.com/henri/spb/blob/readme-images/spb-telemetry-privacy.png?raw=true" width="60%"></a>
</p>
  
Different operating systems and even different LINUX distributions have different stances on privacy and telemetry. As such it is advisable that you check these details for your specific operating system. This project works on a variety of operating systems each with their own particulars relating to privacy and telemetry.

> #### SPB Fish Snippits 
> <sub>Should you use spb-ddg, spb-ddg-ai or spb-pai fish snippits, then you will want to have a close look at the terms of service from [DuckDuckGo](https://duckduckgo.com/privacy) and [Perlexity Ai](https://www.perplexity.ai/hub/legal/privacy-policy) whose websites you will be accessing. If you are using spb-yt then be sure to check [Googles privacy policy](https://policies.google.com/privacy).</sub>

  
### :lock: Security and Trust
You should only run code and use software from sources you trust! 
If you do not trust yourself to check the project code below or you do not trust my judgment, then it is reccomended to not run this code. The alternative is asking someone familar with shell scripting (the language used to create SPB) to vet the code on your behalf. Just make sure if you ask someone to help you vet the code ; that you also trust them. With 25+ years of experience writing shell scripts, you would hope that I have learnt to test my work.
  
Already have spb and fish snippits setup, you may issue the following command to have perplexity vet the code : 
```
spb-pai "would you vet the following project code for malware : https://github.com/henri/spb"
```

<p align="center">
  <!-- <img src="https://gist.github.com/user-attachments/assets/195556ee-8792-4915-a27c-e95d4c09c71f" width="76%"> -->
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#lock-security-and-trust" ><img src="https://github.com/henri/spb/blob/readme-images/spb-security-trust.jpeg?raw=true" width="80%"></a>
</p>
  
### :arrows_counterclockwise: Automate Installation and Updates
The included [spb-update.bash](https://github.com/henri/spb/blob/main/600.spb-update.bash) script may be run interactivly (see [usage above](https://github.com/henri/spb/?tab=readme-ov-file#bookmark_tabs-usage)). Alterativly, you may prefer to start it via a scheduling program (eg.[cron](https://en.wikipedia.org/wiki/Cron)) so that SPB regularly updates automatically. 
  
#### Setup Automated Updates
If you would like to have SPB update automatically, then the [spb-add-to-user-crontab.bash](https://github.com/henri/spb/blob/main/700.spb-add-to-user-crontab.bash) script will load a pre-defined crontab entry which will automatically update SPB each week using the [spb-update.bash](https://github.com/henri/spb/?tab=readme-ov-file#file-600-spb-update-bash) script. The step of running this auto-setup cron script is a manual. The setup of a cron job is not automated in any way beyond manually starting the [spb-add-to-user-crontab.bash](https://github.com/henri/spb/blob/main/700.spb-add-to-user-crontab.bash) script. The easiest way to setup the crontab entry is to run the command below from a bash shell :
  
```bash
export SPB_CRON_SETUP="true"
/bin/bash -c "$(curl -fsSL \
https://raw.githubusercontent.com/\
henri/spb/refs/heads/main/\
500.spb-install-script.bash)"
```
  > <sub>This is the same command used to install SPB, with one key difference : an enviroment varable SPB_CRON_SETUP is set to "ture" and exported.</sub>

The setup of unattended / automated SPB updates (eg. using the command above) will result in default choices being selected which you would normally be able to interactivly select. Also, see [notes regarding telemitry and privacy](https://github.com/henri/spb/?tab=readme-ov-file#shield-telemetry-and-privacy) if you schedule or manually start an SPB update.
  
#### Start Unatteded Updates (automtaically picks default choices)
Start an automated (unattended) update and monitor the progress by running the command below within a shell : 
```
  ~/bin/spb-update.bash --auto-monitoring
```
> <sub> Once the output stream completes (using the command above), press control-c to exit tail and return to your shell.</sub>

#### Roll Your Own
If you are looking to roll your own update system, then the notes below will assist you :
  - Pick a scheduling system (cron, launchd etc..) and add an entry
    - ensure that you export the following enviroment variable (examples for fish and bash are below) :
      - The example update script is written in bash and includes this enviroment varable export already.
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
  
If you export proxy enviroment varables (as showen below) then the SPB install / update scripts will respect these settings and perform network operations via the specified proxy.

```
  # proxy settings for SPB install / update scripts
  
  # bash 
  export http_proxy="http://proxy.server:port"
  export https_proxy="https://proxy.server:port"
  
  # fish 
  set -x http_proxy "http://proxy.server:port"
  set -x export https_proxy "https://proxy.server:port"
  
```

  
### :memo: Licencing, Terms of Use and Legal
SPB is released under the [GNU GPL 3 or later](https://www.gnu.org/licenses/gpl-3.0.html). The GNU GPL is a free software licence which [protects users freedoms](https://www.gnu.org/philosophy/free-sw.en.html). Learn more about [escaping to freedom](https://www.fsf.org/blogs/rms/20140407-geneva-tedx-talk-free-software-free-society). 

### :raising_hand: Why is SPB needed? 

The use cases for this script are immense and include [simplified day-to-day web browsing](https://github.com/henri/spb/?tab=readme-ov-file#star-usage-examples), trouble-shooting, testing, load-testing, AI Agents performing multiple tasks or just having multiple tabs which are not related in terms of cookies etc. 

When starting a private session within the [Safari WebBrowser](https://en.wikipedia.org/wiki/Safari_(web_browser)) on [MacOS](https://en.wikipedia.org/wiki/MacOS) each tab is seperate (the cookies are not shared between tabs). However, most other browsers share the private cookies with all private tabs. One approach is not better or worse. But if you would like to have multiple instances of a browser but not have them sharing all those dirty cookies, then this script allows you to start up all as many private (and separate) sessions as you need and as your system will cope with in terms of system resources. Have fun loading some private browsers.

May the privacy be with you!

:shipit:

---

<p align="center">
  <a href="https://github.com/henri/spb/?tab=readme-ov-file#raising_hand-why-is-spb-needed"><img src="https://github.com/henri/spb/blob/readme-images/spb-may-the-pricacy-be-with-you.png?raw=true"></a>
</p>

--- 

### :warning: Disclaimer
SPB (start private browser) is able to start multiple private browsers. But do not expect more functionaility or privacy from running a browser in incogneto mode. The idea behind SPB is that you can load multiple instances which are somewhat seperated from one and other. Each instance is still running under your user accont and on your system. 

In the event additional privcay is required run SPB within a VM or within a continer. If higher levels of privacy are needed, then consider these projects :

  * [Tails](https://tails.net/)
  * [Whonix](https://www.whonix.org/)
  * [Cubes OS](https://www.qubes-os.org/)
  * [Kasm Workspaces](https://kasmweb.com/)

If you test it and it works on your operating system leave a comment :) or let me know it is not working.
Currently there are no plans to make this work on Microsoft Windows. It may work within the WLS? Give it a try and let me know!

At this stage the script is configured by direct editing. At some point perhaps a config file will be a thing? See the [road map](https://github.com/henri/spb/blob/main/900.roadmap.md) for details.
  
If you decide to setup a [scheduled automatic update](https://github.com/henri/spb/blob/main/700.spb-add-to-user-crontab.bash), then you should trust that I am not going to add any malicious code into this system in the future and that the security of my systems are good enough to prevent someone else pushing malware into the code base. This applies to any software (not just SPB) which automatially updates (even if it is open source). You must alwasy trust the developers sufficiently if you enable auto-updates. This is why by design SPB will not automatically enable auto-updates. SPB expects that if you enable automatic updates you are intentionally placing trust in me to not mess with your system(s) deliberately and that I will secure my systems as the developer sufficiently to protect the SPB code base and build processes less, they break my security in order to take advantage of yours. Remember that any software system which automatically updates via the internet has these same risks.

This project is still in the :seedling: seedling stage (with lots of potetential). If you have suggestions / ideas to improve the way it works, then please [start a discussion](https://github.com/henri/henri/discussions/categories/spb). If you test this on a particular operating system and it works or is not working for you please also leave a comment so that others know to give it a try or not :)

### :rocket: Contributing to the project
In order to protect users of this project all contributors must comply with the [Developer Certificate of Origin](https://developercertificate.org). This ensures that all contributions are properly licensed and attributed.

### :earth_asia: External Resources

**Development / Testing / Automation**
  - [The Pi Guy : Chromium Command Line Tools](https://the-pi-guy.com/blog/chromiums_commandline_tools_and_scripts/)


**General**
  - [Brave : Using Command Line Switches](https://support.brave.com/hc/en-us/articles/360044860011-How-Do-I-Use-Command-Line-Flags-in-Brave)



