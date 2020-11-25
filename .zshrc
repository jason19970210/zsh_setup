
# Last modify datetime : Wed Nov 25 13:45:03 CST 2020

## TODO List
# [ V ] ...
# [   ] check file permission

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

    case "$1" in
        "" | -h | --help) echo "Usgae : objdump_function [TARGET_FILE] [TARGET_FUNCTION]";;
        *)
            case "$2" in
                "" | -h | --help) echo "Usgae : objdump_function [TARGET_FILE] [TARGET_FUNCTION]";;
                *)
                    objdump -M intel -d $1 | awk -v RS= '/^[[:xdigit:]]+ <'$2'>/';;
            esac
    esac
}

function pullzsh {
    echo "Updating alias.sh ..."
    wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh -O ~/.zsh_setup/alias.sh
    echo "Updating ip.sh ..."
    wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh -O ~/.zsh_setup/ip.sh
    echo "Updating .zshrc ..."
    wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/.zshrc -O ~/.zshrc
    src
}

### Call Function
syscheck


if [[ $envos = "macOS" ]]; then

    ## Mac Environment
    #### Environment Variable
    export PATH=/usr/local/bin:$PATH
    export PATH="$(brew --prefix)/bin:$PATH"

    ## Brew Config
    ## Ref : https://docs.brew.sh/Shell-Completion
    ### ZSH Completion
    if type brew &>/dev/null; then
        FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
        autoload -Uz compinit
        compinit
    fi

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
fi



## Both macOS & Linux Ubuntu

### ZSH Autosuggestion
### Download Github repo from `https://github.com/zsh-users/zsh-autosuggestions`
### Source path : ~/.zsh/zsh-autosuggestions
### Uninstallation : `$ rm -rf ~/.zsh/zsh-autosuggestions`
### Delete or comment below line
[ -d ~/.zsh_setup/zsh-autosuggestions ] && : || ( git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_setup/zsh-autosuggestions )
source ~/.zsh_setup/zsh-autosuggestions/zsh-autosuggestions.zsh

### https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)


## Download Script : alias.sh / ip.sh
### Path : ~/.zsh/
### alias.sh download link : https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh
### ip.sh download link : https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh
[ -f ~/.zsh_setup/alias.sh ] && : || (wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh -O ~/.zsh_setup/alias.sh && echo " " | sudo -S chmod +x ~/.zsh_setup/alias.sh)
[ -f ~/.zsh_setup/ip.sh ] && : || (wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh -P ~/.zsh_setup/ip.sh && echo " " | sudo -S chmod +x ~/.zsh_setup/alias.sh)
export PATH=$HOME/.zsh_setup:$PATH


##############################


## Alias
alias q='exit'
alias ls='ls -alh'
alias vimzshrc='vim ~/.zshrc && source $_ && cp ~/.zshrc ~/.zsh_setup'
alias src='source ~/.zshrc'
alias pushzsh='cp ~/.zshrc ~/.zsh_setup && cd ~/.zsh_setup && git add . && git commit -m "Update" && git push'

if [ $envos = "macOS" ]; then
    alias lscpu='echo "$ system_profiler SPHardwareDataType\n" && system_profiler SPHardwareDataType'
    alias speedtest='speedtest-cli'
    alias ghidra='zsh /Users/macbook/Documents/ghidra_v9.2/ghidraRun'

    ## For WireGuard VPN Service (ADL Lab)
    ### https://hq.network/blog/cheatsheet-for-wireguard/
    ### read standard input with `-S` flag
    ### echo <pwd> | sudo -S ...
    alias vpn_on='echo " " | sudo -S wg-quick up ~/.config/wireguard/wg0.conf && echo ' 
    alias vpn_off='wg-quick down ~/.config/wireguard/wg0.conf && echo '
    alias vpn_status='sudo wg show'
fi

### Default Command which will execute every time when shell loaded
ip.sh

echo
