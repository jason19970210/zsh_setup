##############################

# Run after `zsh.sh`
# System Environment Requirement : zsh has been installed !!

#### Functions
check(){  # Check package install or not
    which $1 &> /dev/null
}

syscheck(){
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

syscheck


## Brew Config
## Ref : https://docs.brew.sh/Shell-Completion
### ZSH Completion
#if type brew &>/dev/null; then
#  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
#  autoload -Uz compinit
#  compinit
#fi

if [[ $envos = "macOS" ]]; then

    ## Mac Environment
    #### Environment Variable
    export PATH=/usr/local/bin:$PATH
    export PATH="$(brew --prefix)/bin:$PATH"

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
    ### GDB & peda
    ### Hint : On 10.12 (Sierra) or later with SIP, you need to run this:
    ### $ echo "set startup-with-shell off" >> ~/.gdbinit
    ### Ref of SIP : https://sspai.com/post/55066
    check gdb && : || (brew install gdb && echo "set startup-with-shell off" >> ./.gdbinit)
    [ -d ~/peda/ ] && : || (git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit)
    ### binwalk
    check binwalk && : || (brew install binwalk)
    ### binutils (readelf & objdump)
    [ -d /usr/local/opt/binutils/ ] && : || (brew install binutils)
    ## Ref : https://www.jianshu.com/p/4b93b0665a2b
    ### `$ brew install binutils`
    export PATH="/usr/local/opt/binutils/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/binutils/lib"
    export CPPFLAGS="-I/usr/local/opt/binutils/include"
    ### arp-scan
    check arp-scan && : || (brew install arp-scan)
    export PATH="/usr/local/opt/libpcap/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/libpcap/lib"
    export CPPFLAGS="-I/usr/local/opt/libpcap/include"
    ### Speedtest-cli
    check speedtest-cli && : || (brew install speedtest-cli)
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

    ## Linux Ubuntu Environment
    export PATH=/usr/local/bin:$PATH
    ### zsh autosuggestions
    [ -d ~/.zsh/zsh-autosuggestions ] && : || ( git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions )
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    ### ifconfig
    check ifconfig && : || (sudo apt install net-tools -y)
    ### vim
    check vim && : || (sudo apt install vim -y)
    ### pip3
    check pip3 && : || (sudo apt install python3-pip -y)
    ### gdb & peda
    check gdb && : || (brew install gdb && echo "set startup-with-shell off" >> ./.gdbinit)
    [ -d ~/peda/ ] && : || (git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit)
fi



## Both macOS & Linux Ubuntu
## Hint
echo "Type 'alias.sh' to get alias options !!\n"

## ZSH Prompt Config
PROMPT='%n:%~ %(!.#.$) '

## ZSH History Time Stamp Format
HIST_STAMPS="yyyy/mm/dd"

### ZSH Autosuggestion
### Download Github repo from `https://github.com/zsh-users/zsh-autosuggestions`
### Source path : ~/.zsh/zsh-autosuggestions
### Uninstallation : `$ rm -rf ~/.zsh/zsh-autosuggestions`
### Delete or comment below line
# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

### https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)


## Download Script : alias.sh / ip.sh
### Path : ~/.zsh/
### alias.sh download link : https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh
### ip.sh download link : https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh
[ -f ~/.zsh/alias.sh ] && : || (wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/alias.sh -P ~/.zsh/ && echo " " | sudo -S chmod +x ~/.zsh/alias.sh)
[ -f ~/.zsh/ip.sh ] && : || (wget -q https://raw.githubusercontent.com/jason19970210/zsh_setup/main/ip.sh -P ~/.zsh/ && echo " " | sudo -S chmod +x ~/.zsh/alias.sh)
export PATH=$HOME/.zsh:$PATH


##############################


## Alias
alias q='exit'
alias ls='ls -alh'
alias vimzshrc='vim ~/.zshrc && source $_'
alias src='source ~/.zshrc'

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
    alias vpn_status='echo " " | sudo -S wg show'
fi

### Default Command which will execute every time when shell loaded
ip.sh

echo
