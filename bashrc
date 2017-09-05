#
# ~/.bashrc
#

#################################################
##   If not running interactively, do nothing  ##
#################################################

case $- in
    *i*) ;;
      *) return;;
esac


#################################################
##   Check if SSH session                      ##
#################################################

SSH_SESSION=False
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SSH_SESSION=True
fi


#################################################
##   fortune greeting                          ##
#################################################

if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s
    #fortune | cowsay
fi
echo \


#################################################
##   environment variable                      ##
#################################################

export EDITOR="vim"


#################################################
##   some settings                             ##
#################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Get immediate notification of background job termination
set -o notify

# keep files safe from accidental overwriting
set -o noclobber

# Disable [CTRL-D] which is used to exit the shell
set -o ignoreeof

# Correct dir spellings
shopt -q -s cdspell

# Make sure display get updated when terminal window get resized
shopt -q -s checkwinsize

# Append rather than overwrite history on exit
shopt -s histappend

# git bash completion
source /etc/bash_completion.d/git-prompt

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


#################################################
##   Prompt                                    ##
#################################################

export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\A]\[$(tput setaf 7)\]\w >\[$(tput setaf 1)\]>> \[$(tput sgr0)\]"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


#################################################
##  aliases                                    ##
#################################################

# ### Get os name via uname ###
# _myos="$(uname)"
#
# ### add alias as per os using $_myos ###
# case $_myos in
#    Linux) alias foo='/path/to/linux/bin/foo';;
#    FreeBSD|OpenBSD) alias foo='/path/to/bsd/bin/foo' ;;
#    SunOS) alias foo='/path/to/sunos/bin/foo' ;;
#    *) ;;
# esac

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    alias reboot='sudo reboot'
    alias update='sudo apt-get upgrade'
    alias upgrade='sudo apt-get update && sudo apt-get upgrade'
fi

alias c='clear'

alias ls='ls --color=auto'
alias ll='ls -la'                     # Use a long listing format
alias l.='ls -d .* --color=auto'      # Show hidden files

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'               # Create parent directories on demand

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ping='ping -c 5'
alias ping8='ping 8.8.8.8'

alias h='history'
alias what='type -a'

alias cpu='watch grep \"cpu MHz\" /proc/cpuinfo'
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'


alias bc='bc -l'                    # Start calculator with math support

alias mount='mount |column -t'      # Make mount command output readable

alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias ports='netstat -tulanp'       # show open ports

## fun stuff
alias starwars='telnet towel.blinkenlights.nl 23'
alias excuse='telnet towel.blinkenlights.nl 666'
alias choochoo='sl'
alias matrix='cmatrix'
alias say='espeak'
alias fakeid='rig'
#alias fork=':(){ :|: & };:'


#################################################
##  functions                                  ##
#################################################

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files. Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}

# move filenames to lowercase
function lowercase()
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

# Swap 2 filenames around, if they exist
function swap()
{
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# Handy Extract Program.
function extract()
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Erstellt ein Archiv aus einem angegebenen Verzeichnis
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
