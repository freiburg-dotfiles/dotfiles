unroche(){
    cat $1 | sed 's~controllerType=0 controllerNumber=1 scan=~~g'
}


analyze_repository() {
    python3 "$HOME/git-of-theseus/analyze_repository.py" "$@"
}

#####################################################
#   TENSORFLOW                                      #
#####################################################

# tensorboard function
tb() {
    if [ "$#" -lt 1 ]
    then
        echo "usage: tb GRAPHDIRECTORY [PORTNO]"
    elif [ "$#" -lt 2 ]
    then
        /usr/bin/firefox "http://0.0.0.0:6006/" &&
        tensorboard --logdir="$1" --port "6006"
    else
        /usr/bin/firefox "http://0.0.0.0:$2/" &&
        tensorboard --logdir="$1" --port "$2"
    fi
}

#####################################################
#####################################################

# install an at(1) job to run a python script to add a todoist task 
# to solve a "daily kata" on codewars in a random language of interest.
# (once a day at 10:00 or as close to that as possible)
daily_kata(){
    at_jobs=`atq`
    ids_str=`echo "$at_jobs" | awk '{print $1}'`
    job_ids=()
    while read -r line; do
       job_ids+=("$line")
    done <<< "$ids_str"

    for job_id in $job_ids; do
        job_cmd=`at -c "$job_id"`
        if [[ "$job_cmd" == *"python3 /home/moritz/codewars/random_language.py"* ]]; then
            # there is an active job for today or tomorrow, stop spamming!
            return 0
        fi
    done
    # install job to run next day (or today) at 10:00
    at 10:00 -f "/home/moritz/codewars/.run_at_random_language" 
}


#  print lots in pool {{{ # 

print_pool() {
    python3 "$DOTFILES_REPOSITORY_PATH/freiburg_tf_print/freiburg_tf_print.py" "$@"
}

print_color() {
    python3 "$DOTFILES_REPOSITORY_PATH/freiburg_tf_print/freiburg_tf_print.py" --printer "hpcolor" "$@"
}

#  }}} print lots in pool # 


# add to visudo                    {{{
visudo_add() {
    cmdname=`whereis -b "$@" | awk {'print $2'}`
    echo "ALL ALL = NOPASSWD:$cmdname" | sudo tee "/etc/sudoers.d/$1"
}
#                                               }}}


# insert full pdf2 into pdf1                    {{{
insert_pdf_at_page() {
    if [ "$#" -lt 3 ]
    then
        echo "USAGE: insert_pdf_at_page BIG.pdf TOINSERT.pdf AT_PAGE [OUTFILE.pdf]"
    else
        if [ "$4" ]
        then
            output="$4"
        else
            output="output_merged.pdf"
        fi
        big_pdf="$1"
        small_pdf="$2"
        breakpoint=$(expr "$3" - 1)
        pdftk A="$1" B="$2" cat A1-"$breakpoint" B A"${3}"-end output "$output"
        echo "Wrote merged pdf to file '$output'."
    fi
}

#                                               }}}


# kill process by grepping for regex            {{{
killgrep () {
    python3 "$DOTFILES_REPOSITORY_PATH/killgrep/killgrep.py" "$@"
}
#                                               }}}


# grep in manpage for regex                     {{{
mg () {
    MANARG="$1"
    shift
    man "$MANARG" | grep "$@"
}
#                                               }}}


# SXIV                                  {{{
sxiv() {
    /usr/bin/sxiv "$@" &!
}
#                                               }}}


# CS: CD + LS                                   {{{
cs() {
    if ! [ "$1" ]
    then
        cd "$HOME" && ls
    else
        var=$(expr $# - 1)
        cd "${@: -1}" && ls "${@:1:$var}"
    fi
}
#                                               }}}


# get current weather in given city             {{{
weather() {
    if [ "$1" ] 
    then
        curl wttr.in/$1
    else
        echo "Usage: weather CITY"
        exit(1)
    fi
}



#                                               }}}


# mp4 --> mp3                                   {{{
mp4tomp3() {
    ffmpeg -i "$1" -vn \
        -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 "$2"
}



#                                               }}}


# build + install a new program (with configure arguments) {{{
build() {
    ./configure "$@" && make -j && sudo make -j install
}

#                                               }}}


# Fix broken zsh history file                   {{{
fix_zsh_history() {
    mv "$HOME/.zsh_history" "$HOME/.zsh_history_bad"
    strings "$HOME/.zsh_history_bad" > "$HOME/.zsh_history"
    fc -R "$HOME/.zsh_history"
}
#                                               }}}


# PI: Fast directory switching                  {{{

# Fast access to directories => replace csd,css,etc in the long run
# TODO: Generate/Allow/enable autocompletion for this pi command
function pi() { 
    cmd=$(/bin/grep $1 ~/.pi | head -1)
    if [ -z "$cmd" ]; then
        echo "$1 is not stored as pi-accessible directory yet!"
    fi
    shift
    if [ "$1" ]; then
        cd "$cmd" && cs "$@"
    else
        cs "$cmd"
    fi
}
function addpi() { 
    if [ "$#" = 0 ]; then
        # no arguments => add current path
        echo "$PWD" >> ~/.pi 
    else
        while [[ $# -gt 0 ]]; do
            # arguments = for each directory given as argument, add it 
            # to .pi file for fast access
            argpath="$PWD/$1"
            if [ -d "${argpath}" ]; then
                echo "$PWD/$1" >> ~/.pi
            fi
            shift
        done
    fi
}
function mvpi() {
    cmd=$(/bin/grep $0 ~/.pi | head -1)
    if [ -z "$cmd" ]; then
        echo "$1 is not stored as pi-accessible directory yet!"
        exit 1
    else
        shift
        mv "$@" "$cmd"
    fi
}
#                                               }}}


# Spawn Fortune Cookie                          {{{
 
small_fortune() { 
    string=""
    size=10000
    while [[ "$size" -ge 100 || $string != *"--"* ]]; do
        string=$(fortune people wisdom literature work)
        size=${#string}
    done
    echo "$string"
}

#                                               }}}


# sAsEt-specifics                               {{{

# Open one or many xml-files given as arguments in uppaal side by side.
function open_uppaal () {
    for var in "$@"; do
        ~/Documents/uppaal/uppaal64-4.1.19/uppaal "$var" & disown
    done
}

# Quickly open the labeled uppaal model (with all nonsupporting edges labeled in red) 
# side-by-side with the results of the analysis (with all detected nonsupporting
# edges labeled in red)
function compare_uppaal () {
    label_ex="$HOME/supporting_edges/moritz/tst/labelnonsupp/lns$1"
    nps_ex="$HOME/supporting_edges/moritz/tst/nonpotentialsupport/nps$1"
    for file in "$label_ex"_*.xml.soll; do
        ex_file="$file"
    done
    for file_a in "$nps_ex"_*.xml.soll; do
        nps_file="$file_a"
    done

    open_uppaal "$ex_file" "$nps_file"
}

# run all tests for all implementations for my master project (in subshells,
# which does not take me to the test directory every time!)
function tests_supporting_edge () {
(cd "$HOME/supporting_edges/moritz/tst/labelnonsupp" && ../test.sh -s)
(cd "$HOME/supporting_edges/moritz/tst/nonpotentialsupport" && ../test.sh -s)

}

############################################################################
# Shortcut to run the nonpotentialsupport detection quickly
function saset_nps_run () {
    saset="$HOME/supporting_edges/moritz/bin/x86_64-linux/usaset"
    out=$(mktemp --suff "_nonpotential") &&
    result=$($saset nonpotentialsupp $@) &&
    echo "$result" > "$out"
    ($HOME/Documents/uppaal/uppaal64-4.1.19/uppaal "$out" 2>&1 > /dev/null & ) > /dev/null
}

# Shortcut to run the labeling algorithm quickly
function saset_labelnonsupp_run () {
    saset="$HOME/supporting_edges/moritz/bin/x86_64-linux/usaset"
    out=$(mktemp --suff "_ground_truth") &&
    result=$($saset transform labelnonsupp $@) &&
    echo "$result" > "$out"
    ($HOME/Documents/uppaal/uppaal64-4.1.19/uppaal "$out" 2>&1 > /dev/null &) 2>&1 > /dev/null
}

function clean_up () {
    rm /tmp/z3call_* 2>&1 > /dev/null; 
    rm /tmp/*_ground_truth 2>&1 > /dev/null;
    rm /tmp/*_ground_truth 2>&1 > /dev/null;
    rm /tmp/tmp.*_nonpotential 2>&1 > /dev/null;
    rm /tmp/labelsupp* 2>&1 > /dev/null 2>&1 > /dev/null
 }


function write_tests () {
    input_filename="$1.in.xml"
    num="$2"
    property="$3"
    lns_filepath="$HOME/supporting_edges/moritz/tst/labelnonsupp/lns${num}_${1}.tst"
    lns_call="usaset transform labelnonsupp $input_filename \"($property)\" \"\$1.xml\""
    echo "$lns_call" > "$lns_filepath"
    nps_filepath="$HOME/supporting_edges/moritz/tst/nonpotentialsupport/nps${num}_${1}.tst"
    nps_call="usaset nonpotentialsupp $input_filename \"($property)\" \"\$1.xml\""
    echo "$nps_call" > "$nps_filepath"
}

function benchmark_usaset() {
    USASET="/home/mf113/supporting_edges/moritz/bin/x86_64-linux/usaset"
    runexec -- "$USASET" "$@"
}


#                                               }}}


# Extract any archive                           {{{
 
# added from zshwiki: extract any archive
extract_archive () {
    local old_dirs current_dirs lower
    lower=${(L)1}
    old_dirs=( *(N/) )
    if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
        tar zxfv $1
    elif [[ $lower == *.gz ]]; then
        gunzip $1
    elif [[ $lower == *.tar.bz2 || $lower == *.tbz ]]; then
        bunzip2 -c $1 | tar xfv -
    elif [[ $lower == *.bz2 ]]; then
        bunzip2 $1
    elif [[ $lower == *.zip ]]; then
        unzip $1
    elif [[ $lower == *.rar ]]; then
        unrar e $1
    elif [[ $lower == *.tar ]]; then
        tar xfv $1
    elif [[ $lower == *.lha ]]; then
        lha e $1
    else
        print "Unknown archive type: $1"
        return 1
    fi
    # Change in to the newly created directory, and
    # list the directory contents, if there is one.
    current_dirs=( *(N/) )
    for i in {1..${#current_dirs}}; do
        if [[ $current_dirs[$i] != $old_dirs[$i] ]]; then
            cd $current_dirs[$i]
            ls
            break
        fi
    done
}

#                                               }}}


# Open program and close spawning terminal      {{{

# life manager
manager () {
    echo "$@"
    PPPID=$$
    cd "/home/mf113/manager/" && 
    exec /usr/bin/python2 "manager.py" "$@" & disown
    kill -s SIGKILL $PPPID
}

# firefox/chrome web browser
f () {
   FIREFOX=/usr/bin/google-chrome
   # FIREFOX="$HOME/Downloads/firefox/firefox"
   if  (($# >= 2)); then
        # If we have more than 2 arguments, some options were specified. 
        # Run firefox normally.
        exec "$FIREFOX $@" & disown
    else
        PPPID=$$
        if [ "$1" ]; then
            # Exactly one argument! We were called with some url
            # => just open it and kill my nasty terminal.
            exec "$FIREFOX $1" & disown
        else
            # No arguments => open empty instance
            exec "$FIREFOX" & disown
        fi
        kill -s SIGKILL $PPPID
    fi
}

#  spacemacs {{{ # 
# emacs
e () {
    /usr/bin/emacsclient -nw "$@"
}

restart_emacs_server() {
    killgrep "[e]macs --daemon" &&
    /usr/bin/emacs --daemon
}

#  }}} spacemacs # 

# vim
v () {
    random_string=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    /usr/bin/vim -p --servername "$random_string" "$@"
}
#                                               }}}


# zathura pdf viewer  {{{
z () {
    # the {...} stuff is for autocompletion...
    command zathura ${*:-*.pdf(om[1])} & disown
}

#                                               }}}


# Smart shutdown                                {{{

function sd() {
    # no argument = now
    if [ -z "$1" ]; then
        sudo shutdown -P now
    else
        # argument = treated as minutes
        sudo shutdown -P "$1"
    fi
}

#                                               }}}


#  Smart reboot {{{ # 
function re() {
    # no argument = now
    if [ -z "$1" ]; then
        sudo shutdown --reboot now
    else
        # argument = treated as minutes
        sudo shutdown --reboot "$1"
    fi
}
#  }}} Smart reboot # 


#  Make directory and move into it at the same time {{{ # 

function mkd() {
    mkdir -p "$@" && cd "$_"
}

#  }}} Make directory and move into it at the same time # 


#  Pack+Pipe file to ssh server {{{ # 

# pipe a given file (first argument) to a ssh server.
# example usage: pipe_ssh "test.txt" "ssh test@test.testtest.com"
function pipe_ssh() {
   if [[ $# -eq 0 ]]; then 
       echo "USAGE: pipe_ssh FILENAME ssh test@test.testtest.com"
   else
       tar zcf - "$1" | "${@:2}" 'tar zxf -'
   fi
}

#  }}} Pack+Pipe file to ssh server # 


#  Most Frequently Used Commands {{{ # 
most_used_commands() {
    if [[ "$1" = "--help" || "$1" = "-h" ]]; then
        echo "USAGE: most_used_commands [NUMBER_OF_COMMANDS=10]"
    else
        no="10"
        if [ "$1" ]; then
            no="$1"
        fi
        cat ~/.zsh_history | awk '{CMD[$1]++;count++;}END { for (a in CMD)print CMD[a]" "CMD[a]/count*100 "% "a;}' | /bin/grep -v ",/" | column -c3 -s " " -t | sort -nr | nl | head -n$no
    fi
}
#  }}} Most Frequently Used Commands # 

copy_to_elementary() {
    ELEM_OS_LOC="/mnt/elementary_os"
    if [[ $# -eq 0 ]]; then
        echo "Specify at least one file to move!" && exit 1 
    else
        sudo mount /dev/sda2 "$ELEM_OS_LOC" && cp "$@" "$ELEM_OS_LOC/home/mf113";
        sudo umount "$ELEM_OS_LOC"
    fi 
}
