
# Last modify datetime : Fri Nov 27 02:36:37 CST 2020

## TODO List
# [ V ] ...
# [   ] < All >    Check file permission
# [   ] < All >    Make suggestion with tab (objdump_function)
# [   ] < macOS >  Install pwntools (ref : https://home.gamer.com.tw/creationDetail.php?sn=4871978)
#       - brew install pwntools binutils ( Installation Path : /usr/local/Cellar/pwntools )
#       - cd /usr/local/lib/python3.9/site-packages (Where `site-packages` located )
#       - echo "/usr/local/Cellar/pwntools/4.3.0/libexec/lib/python3.9/site-packages" >> pwntools.pth ( Insert env variable with pth file )
# [   ] < macOS >  Install ghidra
# [   ] < All >    Get config file of wireguard file
# [   ] < Linux >  Install full tools for GDB
#       - ref : https://github.com/apogiatzis/gdb-peda-pwndbg-gef
#       - ref : https://medium.com/bugbountywriteup/pwndbg-gef-peda-one-for-all-and-all-for-one-714d71bf36b8

##############################

## Hint
echo "Type 'alias.sh' to get alias options !!\n"

## ZSH Prompt Config
PROMPT='%n:%~ %(!.#.$) '

## ZSH History Time Stamp Format
HIST_STAMPS="yyyy/mm/dd"

## Set Terminal Language to en_US
export LANG="en_US.UTF-8"


## Check file existed or not
## Ref : https://linuxize.com/post/bash-check-if-file-exists/
[ ! -f ~/.zshrc ] && (wget https://raw.githubusercontent.com/jason19970210/zsh_setup/main/.zshrc -O ~/.zshrc && source ~/.zshrc ) || :

#### Functions
## Use `function FUNC_NAME {}` to make it avaliable with alias.sh
function check {
    # Check package install or not
    which $1 &> /dev/null
}


syscheck() {
    ## Check Working OS
    case "$OSTYPE" in
        solaris*)   envos="Solaris" ;;
        darwin*)    envos="macOS" ;;
        linux*)     envos="Linux" ;;
        bsd*)       envos="BSD" ;;
        *)          echo "Unknown OSTYPE: $OSTYPE" ;;
    esac

    ## Check Default Shell
    case "$SHELL" in
        */bin/sh)    envsh="sh" ;;
        */bin/bash)  envsh="bash" ;;
        */bin/zsh)   envsh="zsh" ;;
        *)          envsh="other" ;;
    esac
}

function objdump_function {
    
    # $ objdump_function
    
    # $ objdump_function -h
    # $ objdump_function --help
    # $ objdump_function file
    
    # $ objdump_function file func
    
    # $ objdump_function -a file -f func
    
    if [ $# = 0 ]; then
        echo "Usage"
        exit 1
    elif [ $# = 1 ]; then
        case "$1" in
            -h | --help) echo "Usage" ;;
            *) objdump -M intel -d $1 | grep ^0 | awk -F: '{print $1}' ;;
        esac
    elif [ $# = 2 ]; then
        objdump -M intel -d $1 | sed '/<'$2'>:/,/^$/!d'

    elif [ $# = 4 ]; then
        case "$1" in
            -a) 
                case "$3" in
                    -f) 
                        objdump -M intel -d $1 | sed '/<'$2'>:/,/^$/!d' ;;
                    *)
                        echo "Usage" ;;
                esac ;;
            *)
                echo "Usage" ;;
        esac
    fi
    
    
    #case "$1" in
    #    "" | -h | --help) echo "Usgae : objdump_function [TARGET_FILE] [TARGET_FUNCTION]";;
    #    -a)
    #        [ -f $2 ] && : || (echo "File not found !" && exit 1) ;;
            
        
        #-f | --function)
            #objdump -M intel -d $1 | grep ^0 | cut -c 19- | awk 'BEGIN {FS=">"}; { print " " $1}'
        #    objdump -M intel -d $2 | grep ^0 | awk -F: '{print $1}' ;;   
    #    *)
    #        case "$2" in
                # no second argument
    #            "") objdump -M intel -d $1 | grep ^0 | awk -F: '{print $1}';;
    #            -h | --help) echo "Usgae : objdump_function [TARGET_FILE] [TARGET_FUNCTION]";;
    #            *)
    #                objdump -d $1 | sed '/<'$2'>:/,/^$/!d';;
    #        esac
    #esac
}

function pullzsh {
    echo "Updating alias.sh ..."
    wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh -O ~/.zsh_setup/alias.sh
    echo "Updating ip.sh ..."
    wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh -O ~/.zsh_setup/ip.sh
    echo "Updating .zshrc ..."
    wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/.zshrc -O ~/.zshrc && source $_
}

### Call Function
syscheck


if [[ $envos = "macOS" ]]; then

    ## Mac Environment
    
    #### Finder Config
    $(defaults read com.apple.Finder AppleShowAllFiles) && : || (defaults write com.apple.Finder AppleShowAllFiles true)
    
    #### Environment Variable (Priority Sensitive)
	## Allow brew package instead of pre-installed from macOS origin package
    export PATH="$(brew --prefix)/bin:$PATH"
	export PATH="/usr/local/sbin:$PATH"
    #export PATH=$HOME/.zsh_setup:$PATH
	export PATH=/usr/local/bin:$PATH
	
	## Enable ZSH with `Colors`
	#export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	#eval $(gdircolors -b $HOME/.dircolors)
	#if [ -n "$LS_COLORS" ]; then
	#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
	#fi
	# ==== #
	#autoload -U colors
	#colors
	#export clicolor=1
	# ==== #
	## The BEST way
	# Ref : https://www.cyberciti.biz/faq/apple-mac-osx-terminal-color-ls-output-option/
	export CLICOLOR=1
	export LSCOLORS=GxFxCxDxBxegedabagaced ## By changing this color serials to make different color of file type [See Ref link]

	# https://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text
	# PROMPT='%F{240}%n%F{red}@%F{green}%m:%F{141}%d$ %F{reset}'  ## This will change the Prompt color 

    

    ## Brew Config
    ## Ref : https://docs.brew.sh/Shell-Completion
    ### ZSH Completion
    if type brew &>/dev/null; then
        FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
        autoload -Uz compinit
        compinit
    fi

	### ZSH Syntax Highlight
    ### brew install zsh-syntax-highlighting
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    #### Functions
    ### Allow using `code` command to exec VScode
    ### Only for zsh
    ### Ref : https://consultwithgriff.com/how-to-run-visual-studio-code-from-mac-osx/
    function code {
        if [[ $# = 0 ]]; then
            open -a "Visual Studio Code"
        else
            local argPath="$1"
            [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
            open -a "Visual Studio Code" "$argPath"
        fi
    }

    ## `:` means do nothing in shell script
    ## Package Installation
    ### git
    check git && : || brew install git
    ### xcode-select --install | -p 
    ### GDB & peda
    ### Hint : On 10.12 (Sierra) or later with SIP, you need to run this:
    ### $ echo "set startup-with-shell off" >> ~/.gdbinit
    ### Ref of SIP : https://sspai.com/post/55066
    check gdb && : || ( brew install gdb && echo "set startup-with-shell off" >> ./.gdbinit )
    [ -d ~/peda/ ] && : || ( git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit )
    ### binwalk
    check binwalk && : || ( brew install binwalk )
    ### binutils (readelf & objdump)
    [ -d /usr/local/opt/binutils/ ] && : || ( brew install binutils )
    ## Ref : https://www.jianshu.com/p/4b93b0665a2b
    ### `$ brew install binutils`
    export PATH="/usr/local/opt/binutils/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/binutils/lib"
    export CPPFLAGS="-I/usr/local/opt/binutils/include"
    ### arp-scan
    check arp-scan && : || ( brew install arp-scan )
    export PATH="/usr/local/opt/libpcap/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/libpcap/lib"
    export CPPFLAGS="-I/usr/local/opt/libpcap/include"
    ### Speedtest-cli
    check speedtest-cli && : || ( brew install speedtest-cli )
    ### wireguard-tools
    check wg && : || brew install wireguard-tools
    ### Ghidra
    ### ...

    ### JDK / Java Runtime Environment Config
    ### By downloading the jdk-15.0.1_osx-x64_bin.tar
    ### Extract >> <jdk-15.0.1.jdk>
    export JAVA_HOME=/Users/macbook/Documents/jdk-15.0.1.jdk/Contents/Home
    export PATH=$JAVA_HOME/bin:$PATH

elif [[ $envos = "Linux" ]]; then

    if [ $envsh != "zsh" ]; then
        check zsh && : || (sudo apt install zsh)
        chsh -s $(which zsh) && gnome-session-quit --no-prompt
    fi
    ### show-date-in-top-bar
    ### Ref : https://askubuntu.com/questions/1040306/how-to-show-date-in-top-bar-of-deskop-in-ubuntu-18-04-lts
    $(dconf read /org/gnome/desktop/interface/clock-show-date) && : || (dconf write /org/gnome/desktop/interface/clock-show-date 'true') 
    ## Linux Ubuntu Environment
    export PATH=/usr/local/bin:$PATH
    ### ifconfig
    check ifconfig && : || (sudo apt install net-tools -y)
    ### vim
    check vim && : || (sudo apt install vim -y)
    ### pip3
    check pip3 && : || (sudo apt install python3-pip -y)
    ### gdb & peda
    check gdb && : || ( sudo apt install gdb && echo "set startup-with-shell off" >> ./.gdbinit )
    [ -d ~/peda/ ] && : || ( git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit )
    ### binwalk
    check binwalk && : || (sudo apt install binwalk -y)
    ### one_gadget
    ### https://github.com/david942j/one_gadget
    check gem && : || (sudo apt install ruby -y && sudo gem install one_gadget)
    check checksec && : || (pip3 install pwntools)
    chech docker && : || (sudo apt install docker.io && sudo chmod 666 /var/run/docker.sock)
    ### Change Permission to avoid error while `docker pull` command
fi



## Both macOS & Linux Ubuntu

### ZSH Autosuggestion
### Download Github repo from `https://github.com/zsh-users/zsh-autosuggestions`
### Source path : ~/.zsh/zsh-autosuggestions
### Uninstallation : `$ rm -rf ~/.zsh/zsh-autosuggestions`
### Delete or comment below line
[ -f ~/.zsh_setup/zsh-autosuggestions/zsh-autosuggestions.zsh ] && : || ( git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_setup/zsh-autosuggestions )
source ~/.zsh_setup/zsh-autosuggestions/zsh-autosuggestions.zsh

### https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

# Disable annoying confirm
setopt no_nomatch

### Dirsearch
[ -d ~/dirsearch/ ] && : || (git clone https://github.com/maurosoria/dirsearch ~/dirsearch && export PATH=$HOME/dirsearch:$PATH)

## Download Script : alias.sh / ip.sh
### Path : ~/.zsh/
### alias.sh download link : https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh
### ip.sh download link : https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh
[ -f ~/.zsh_setup/alias.sh ] && : || (wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh -O ~/.zsh_setup/alias.sh && echo " " | sudo -S chmod +x ~/.zsh_setup/alias.sh)
[ -f ~/.zsh_setup/ip.sh ] && : || (wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh -P ~/.zsh_setup/ip.sh && echo " " | sudo -S chmod +x ~/.zsh_setup/alias.sh)
export PATH=$HOME/.zsh_setup:$PATH


### Checksec Installation
### Download link : https://github.com/slimm609/checksec.sh
### download zip file
### $ unzip checksec.sh-2.4.0.zip
### $ cp checksec.sh-2.4.0.zip ~/.zsh_setup


##############################


## Alias
alias q='exit'
alias ls='ls -alh'
alias vimzshrc='vim ~/.zshrc && source $_ && cp ~/.zshrc ~/.zsh_setup'
alias src='source ~/.zshrc'
alias pushzsh='cp ~/.zshrc ~/.zsh_setup && cd ~/.zsh_setup && git add . && git commit -m "Update" && git push'
alias dirsearch='dirsearch.py'

if [ $envos = "macOS" ]; then
    alias lscpu='echo "$ system_profiler SPHardwareDataType\n" && system_profiler SPHardwareDataType'
    alias speedtest='speedtest-cli'
    alias ghidra='zsh /Users/macbook/Documents/ghidra_v9.2/ghidraRun'
	alias purge='echo " " | sudo -S purge'

    ## For WireGuard VPN Service (ADL Lab)
    ### https://hq.network/blog/cheatsheet-for-wireguard/
    ### read standard input with `-S` flag
    ### echo <pwd> | sudo -S ...
    alias vpn_on='echo " " | sudo -S wg-quick up ~/.config/wireguard/wg0.conf && echo ' 
    alias vpn_off='wg-quick down ~/.config/wireguard/wg0.conf && echo '
    alias vpn_status='sudo wg show'
	
	# Run each time when terminal open
	purge > /dev/null 2>&1
fi

### Default Command which will execute every time when shell loaded
ip.sh
printf "%-12s: %s\n" Oper\ System $envos

echo
