# Generic .profile for sh, ksh and bash shells
# OS specific additions/overrides should go to:
# $DOT_HOME/.profile_linux     Linux systems
# $DOT_HOME/.profile_solaris   Solaris systems
# $DOT_HOME/.profile_cygwin    Windows XP/NT/2k systems using cygwin
# $DOT_HOME/.profile_aix       AIX systems
# $DOT_HOME/.profile_hp        HP-UX systems

#DOT_HOME should point to directory containing this .profile
# $HOME will work as long as $HOME always points to the directory where 
# this .profile resides. This may not be the case if the user does "sudo ksh" 
# and then ". /path/.profile"?

# DOT_HOME is set in .bashrc and should be more reliable, if using this .profile from a bash shell
#echo ".profile:  dot_home: $DOT_HOME"

#Fall back to using $HOME if DOT_HOME is not set, i.e. when using ksh or sh
#  $HOME will not always work to locate the os specific .profile files, such as
#  when you "su - root" on Solaris and then ". /export/home/username/.profile under ksh or sh
#  In this case, $HOME is reset to / and this script will not find the OS specific files.
#  The solution is to always do "su root" or just "su" and then ". /export/home/username/.profile"
#  if you really want to use sh or ksh.

PROFILE_HOME=${DOT_HOME:-`dirname "${HOME}/.profile"`}
export PROFILE_HOME
#echo ".profile: profile_home is $PROFILE_HOME"

# OS/shell common settings
PATH=/usr/bin:\
/bin:\
/usr/sbin:\
/sbin:\
/etc:\
/usr/local/bin:\
$HOME/bin:\
.:\
$PATH

LD_LIBRARY_PATH=/usr/lib
export LD_LIBRARY_PATH

MANPATH=/usr/share/man
PROFILE=true
EDITOR=vi
VISUAL=vi
PAGER=less
LANG=C

include (){
  if [ -r "$1" ]; then
    . "$1"
  fi
}

#OS specific override settings
MY_HOST=`uname -n`
case "`uname -s | cut -d_ -f1`" in
  Linux)
    include "${PROFILE_HOME}/.profile_linux"
    include "${PROFILE_HOME}/.profile_linux_${MY_HOST}"
    ;;
  SunOS)
    include "${PROFILE_HOME}/.profile_solaris"
    include "${PROFILE_HOME}/.profile_solaris_${MY_HOST}"
    ;;
  CYGWIN) #Win XP, 2000, NT, Vista?
    include "${PROFILE_HOME}/.profile_cygwin"
    include "${PROFILE_HOME}/.profile_cygwin_${MY_HOST}"
    ;;
  HP-UX) 
    include "${PROFILE_HOME}/.profile_hp"
    include "${PROFILE_HOME}/.profile_hp_${MY_HOST}"
    ;;
  AIX)  #AIX
    include "${PROFILE_HOME}/.profile_aix"
    include "${PROFILE_HOME}/.profile_aix_${MY_HOST}"
    ;;
  *)
    ;;
esac

# Setup PS1 (prompt) for sh and ksh.
# This prompt also works for a basic, boring bash prompt 
# bash settings are overridden in .bashrc

USER=`whoami` 
#if ( "$?" -ne "0" ) then
#  USER=`/usr/ucb/whoami`
#fi
HOSTNAME=`uname -n`
case "$USER" in
  root)
    CHAR="#"
    ;;
  *)
    CHAR="$"
    ;;
esac

case "$0" in
  ksh|*bash*)
#    echo "TERM is $TERM"
    case $TERM in
      xterm*|dtterm*|terminator|rxvt*)
        PS1=']0;${USER}@${HOSTNAME}:${PWD}
\! [${USER}@${HOSTNAME}:${PWD}]
${CHAR} '
        ;;
      sun-cmd*)
        PS1=']l ${USER}@${HOSTNAME}:${PWD}\\
[${USER}@${HOSTNAME}:${PWD}]
\! ${CHAR} '
        ;;
      *)
        PS1='
[ ${USER}@${HOSTNAME}:${PWD}]
\! ${CHAR} '
        ;;
    esac
    ;;
  sh)
    PS1="[${USER}@${HOSTNAME}] ${CHAR} "
    ;;
  *)
    PS1="unknown shell$ "
    ;;
esac #case "$0"
#echo "profile PS1: $PS1"

#Customized history settings
HISTFILE=$HOME/tmp/.ksh.history".${TTY}"
HISTSIZE=1000
FCEDIT=vi
ENV=$HOME/.profile
export FCEDIT PROFILE EDITOR VISUAL PAGER HOSTNAME PATH MANPATH PS1 HISTFILE HISTSIZE ENV LANG

# OS agnostic settings not always safe for Bourne shell
if [ "$0" != "sh" -a "$0" != "-sh" ]; then
  set -o emacs

  #stupid finger patch
  alias mroe=more
  alias gerp=grep
  alias grpe=grep
fi

#echo "exit .profile "
