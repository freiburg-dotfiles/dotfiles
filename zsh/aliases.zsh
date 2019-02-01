alias molmed_server="xfreerdp +home-drive +clipboard +fonts -grab-keyboard /monitors:0 /f -themes -wallpaper /v:132.230.131.5 /u:moritz"

alias calc="/usr/lib/libreoffice/program/scalc"

# Unix Commands                                         {{{

#  Python {{{ # 

#  BPython {{{ # 

alias b="bpython"
alias b3="bpython"

alias jp="jupyter notebook &!"

#  }}} BPython # 

alias pt="pytest"
alias python3.6="~/.pyenv/versions/3.6.0/bin/python3.6"
alias b3.6="python3.6 ~/.pyenv/versions/3.6.0/lib/python3.6/site-packages/bpython/cli.py"
alias pip3.6="~/.pyenv/versions/3.6.0/bin/pip3.6"

# python shortcuts
alias p="python"
alias p3="python3"

alias upgrade-pips="sudo pip install --upgrade pip && sudo pip3 install --upgrade pip"

#  }}} Python # 

alias knime="$HOME/Downloads/knime/knime-full_3.4.1/knime"
alias julia='PATH="$PATH:$HOME/Downloads/julia-ae26b25d43/bin/"; julia'

alias print_tf="python3 $HOME/freiburg_tf_print/freiburg_tf_print.py"
alias eclimd="$HOME/eclipse/eclimd"

alias check_style='find . -name "*.tex" -exec check_style.py {} \;'

alias pdf_presenter_console="xset r rate && /usr/bin/pdf_presenter_console"

alias mtex="python $DOTFILES_REPOSITORY_PATH/tex_makefile.py"

# black out screen and wait for enter key press
alias blackout="sudo sh -c 'vbetool dpms off; read ans; vbetool dpms on'"

# always also make parent directories
alias mkdir="mkdir -p"

# blinkist cards
alias blink='ankifordeck blinkist'

# semi-graphic network manager thing
alias net='nm-tool'


# locate file
alias loc="locate"

# alias to copy directories just like files
alias cp='cp -r'

# make grep retain colors
alias grep="grep --color='always'"

# some more ls aliases
alias ls="ls --color='always'"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# less maintains colors
alias less='less -R'

# reboot
alias re='sudo reboot now'

# mutt
alias mu='mutt'

# alsamixer (make darker)
alias al='alsamixer -g -c 1'

# vim (open as server)
alias v="vim"

# anki-vim
alias ankifordeck='cd ~/anki-vim/ && python ~/anki-vim/anki-vim.py -d '

# start redshift correctly for grenzach-wyhlen 
alias gtk-redshift='gtk-redshift -l 47.55:7.65 & disown'

# android studio
alias android='/home/mf113/android-studio/bin/studio.sh'

# shortcuts for copy/paste
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias modprobe="sudo modprobe"

# avoid screen turning black
alias keep_screen_on="xset s off && xset -dpms"


#                                                       }}}

alias lsfind="python3 $DOTFILES_REPOSITORY_PATH/lsfind/lsfind.py"

alias binacluster="ssh fr_mn119@login01.binac.uni-tuebingen.de"                 


#  ROS {{{ # 
alias setup_ros="zsh /opt/ros/kinetic/setup.zsh"
#  }}} ROS # 


#  IDE {{{ # 

alias idea="source ~/Downloads/idea-IC-162.2228.15/bin/idea.sh"

#  }}} IDE # 


# sAsEt-specifics                                       {{{

# uppaal
alias upp='~/Documents/uppaal/uppaal64-4.1.19/uppaal'
zstyle ':completion:*:*:upp:*:*' file-patterns '*.xml:*.in.xml:*..xml.soll' '%p:all-files'

alias acc="accept.sh"

alias htuplevel='/home/mf113/hiwijob/trunk/bin/x86_64-linux/tuplevel.sh'
alias tuplevel='/home/mf113/supporting_edges/moritz/bin/x86_64-linux/tuplevel.sh'

alias benchexec_setup="sudo mount -t cgroup cgroup /sys/fs/cgroup && sudo chmod o+wt,g+w /sys/fs/cgroup/ && sudo swapoff -a"

#                                                       }}}


# Filetype -> Tool mappings                             {{{

alias -s cpp='vim'
alias -s ml='vim'
alias -s pdf='z '
alias -s tex='vim'
alias -s png='sxiv'
alias -s jpg='sxiv'
alias -s JPG='sxiv'
alias -s jpeg='sxiv'

alias -g G="| grep"
alias -g L="| less"
alias -g HL="--help"
alias -g D="& disown"

#                                                       }}}


# Version Control                                       {{{

# GIT                                               {{{

alias ga='git add'
alias gi='git commit -m "interim" && git push'
alias gc='git commit && git push'
alias gu='git pull'
alias gp='git push'

#                                                   }}}


# SVN                                               {{{

alias sa='svn add'
alias si='svn commit -m "interim"'
alias sc='svn commit'
alias su='svn up .'

#                                                   }}}

#                                                       }}}


# Archives (Extraction/Packing)                         {{{

alias pack='tar -zcvf '
alias ex=extract_archive

#                                                       }}}


# Navigation                                            {{{

alias ..='cs ..'
alias ...="cs ../.."
alias ....="cs ../../.."

# alias to quickly change to snippet creation/editing directory
alias cssn='cs ~/.vim/bundle/vim-snippets/UltiSnips/'
# alias to quickly change to vim swap storage (to remove swap files after 
# successful recovery)
alias cssw='cs ~/.vim/swaps/'

#                                                       }}}


# MAKE                                                  {{{

# alias make in parallel shortcut
alias m='make -j'
# alias make in parallel shortcut
alias make="make -j"
# alias make utoplevel
alias mm='make -j && make utop -j && make tuplevel -j'
# alias make clean
alias mc='make clean'
# alias make very clean
alias mvc='make veryclean'
#                                                       }}}


#  USB (Mount/Unmount) {{{ # 

#  Mount {{{ # 

alias mount-usb='udisksctl mount -b /dev/sdb1'
alias usb-mount='mount-usb'

#  }}} Mount # 

#  Unmount {{{ # 

alias unmount-usb='cd && udisksctl unmount -b /dev/sdb1 && {cd "$OLDPWD" > /dev/null}'
alias usb-unmount='unmount-usb'

#  }}} Unmount # 

#  }}} USB (Mount/Unmount) # 


# Configuration File Editing                            {{{

alias vv='vim ~/.vimrc'
alias ee="/usr/bin/emacsclient -nw ~/.spacemacs"
alias zz="vim ~/.zshrc && zsh"
alias ff='vim ~/.zsh/functions.zsh && zsh'
alias aa='vim ~/.zsh/aliases.zsh && zsh'
alias ii="vim ~/.i3/config"

#                                                       }}}


# SSH Mappings                                          {{{

alias akoakoa='ssh freidanm@akoakoa.informatik.uni-freiburg.de'
alias -g akoakoa='ssh freidanm@akoakoa.informatik.uni-freiburg.de'

alias -g ssh_pool='ssh freidanm@login.informatik.uni-freiburg.de'
alias ssh_pool='ssh freidanm@login.informatik.uni-freiburg.de'

alias mloadcluster='ssh -t freidanm@login.informatik.uni-freiburg.de "ssh -t metasub2.rz.ki.privat"'
alias -g mloadcluster='ssh -t freidanm@login.informatik.uni-freiburg.de "ssh -t metasub2.rz.ki.privat"'

alias raspberry1="ssh ubuntu@192.168.2.99"
alias -g raspberry1="ssh ubuntu@192.168.2.99"

print_pool() {
    username="$1"
    filepath="$2"
    # copy file to pool server
    scp "$filepath" "$username@login.informatik.uni-freiburg.de:/home/$username/"
    # print and drop to shell
    ssh -t "$username@login.informatik.uni-freiburg.de" "lpquota; bash -l"
    # XXX: Use this to print!
    # XXX: Find first non-busy printer!
    #ssh -t "$username@login.informatik.uni-freiburg.de" "lpr -Php14; bash -l"
    #ssh -t "$username@login.informatik.uni-freiburg.de" "lpr -Php15; bash -l"
    # XXX: Notify when job is done
}

#                                                       }}}


# APT-GET convenience mappings                         {{{

alias ins="sudo apt-get install -y"
alias upd="sudo apt-get update -y"
alias upg="sudo apt-get upgrade -y"
alias cache-search="sudo apt-cache search"

#                                                       }}}


# Restore broken things (danger control)                {{{
alias aaaa="xset r rate 100 80"
alias aaaaa="xset r rate 65 115"
alias aaaaaa="xset r rate 65 115"

alias fix_visudo="pkexec visudo"
#                                                       }}}


# AG Searching Customizations                           {{{
alias ag="ag --color-line-number='4;36' --color-path='4;36'"
#                                                       }}}
#

alias planner="/home/moritz/hashcode/fast_downward/fast-downward.py"
alias translate="python3 /home/moritz/hashcode/fast_downward/builds/release32/bin/translate/translate.py"
