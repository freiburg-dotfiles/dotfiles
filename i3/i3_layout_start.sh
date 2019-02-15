#! /bin/bash
xmodmap ~/.xmodmap


#python "$HOME/focused_window/toggle_mouse_firefox.py" & disown
python "$HOME/warn_battery/warn_battery_low.py" & disown

# break reminder
python3 "/home/moritz/dotfiles/tools/break_reminder/break-reminder.py" --worktime=50 --breaktime=10 & disown


# Start network manager applet first, to be able to see if we have inet
nm-applet & disown 

# Start a emacs server daemon so that starting spacemacs gets significant speedup
emacs --daemon & disown

# Check whether i net is running
wget -q --tries=10 --timeout=20 --spider http://google.com
# assert that inet runs correctly and that we are not in Telekom_ICE (they only
# want money!)
if [[ $? -eq 0 ]] && ! [ "$(iwgetid -r)" = "Telekom_ICE" ]; then
    # Start redshift-gtk in a mode that grabs the geolocation from the internet
    redshift-gtk & disown
    i3-msg 'workspace 3; exec firefox -P fun;workspace 3' & disown
    # Open a terminal on workspace 6
    i3-msg 'workspace 3; exec i3-sensible-terminal' & disown
    # Open a firefox instance with my wunderlist on workspace 3
    i3-msg 'workspace 2; exec firefox -P default;' & disown
    # run skype on startup (on fifth workspace)
    skype & disown
    i3-sensible-terminal -title 'mutt mail' -e mutt -n
else
    # run code that runs without network
    # Start redshift-gtk in "manual" mode which does not require network
    # connections to get my geolocation
    command -v redshift && redshift-gtk -l 47.50:7.60 & disown
    # Open a terminal on workspace 4 
    i3-msg 'workspace 3; exec i3-sensible-terminal' & disown
    # Open a terminal on workspace 5 
    i3-msg 'workspace 2; exec i3-sensible-terminal' & disown
    # Open a terminal on workspace 6
    i3-msg 'workspace 1; exec i3-sensible-terminal' & disown
fi
