#!/usr/bin/env/python
# -*- coding: iso-8859-15 -*-
"""
Author: Moritz Freidank, 18.07.2016

Script to gradually increase keyboard responsitivity,
which is useful for faster navigation in editors such as 'vim(1)'.

Makes some sanity checks (e.g. maintains bounds for the responsitivity values)
and is customisable with respect to the intervals at which increasing
is done, the increments at which the keyboard speed increases as well as
the bounds for the responsitivity values.
"""

import datetime
import os

# File that tracks when we last increased keyboard speed
LAST_UPDATED = os.path.expanduser("~/speed_up_keyboard/data/last_updated.txt")
# File that contains actual 'xset(1)' call to increase keyboard responsitivity.
SPEED_FILE = os.path.expanduser("~/.zsh/keyboard_speed.zsh")


def have_days_passed(days=14, update_file=LAST_UPDATED):
    """
        Parses the time when we last increased speed from the file
        :update_file: and checks if this date is older than :days: days.


    :days: Number of days to wait before increasing again.
    :update_file: File path to a file that tracks date on which time was
                  last incremented.
    :returns: 'True' if the last speed update was more than :days: days ago,
              'False' otherwise

    """
    with open(update_file, 'r') as f:
        try:
            last_modified = datetime.datetime.strptime(f.read(),
                                                       '%Y-%m-%d')
        except:
            last_modified = None

    today = datetime.datetime.today()
    return (not last_modified or
            (today - last_modified) > datetime.timedelta(days=days))


def increase_keyboard_speed(delay_increment=5, repeatrate_increment=5,
                            delay_min_value=70, repeatrate_max_value=200):
    """
        Increases the keyboard speed by:
            - decreasing the amount of time a key needs to be pressed before
              activating a key event by :delay_increment: (with cutoff at
              :delay_min_value:)

            - increasing the rate at which keyevents are repeated by
              :repeatrate_increment: (with cutoff at :repeatrate_max_value:)
        Speed increase is achieved by maintaining a call to 'xset(1)' in
        "SPEED_FILE". This file is sourced when my x-server starts.

    :delay_increment: number of milliseconds to remove from
                      time it takes before pressing a key activates a key event
    :repeatrate_increment: number of HZ to add to the current rate at which
                           key events are repeated if a key is pressed.
    :delay_min_value: minimal amount of milliseconds to ever assign to
                      the waiting time for a key event when a key is pressed.
    :repeatrate_max_value: maximal amount of HZ at which to trigger new key
                           events when a key is held.
    """

    with open(SPEED_FILE, 'r') as f:
        lines = f.readlines()
        xset_str = lines[-1].split()[:-2]
        (delay, repeatrate) = tuple(map(int,
                                        lines[-1].strip().split()[-2:]))
        new_delay = max(delay_min_value, delay - delay_increment)
        new_repeatrate = min(repeatrate_max_value,
                             repeatrate + repeatrate_increment)
        (delay, repeatrate) = (new_delay, new_repeatrate)
        print("Automatically decreased keyboard delay to: {}".format(delay))
        print("Increasing keyboard repeat rate to: {}".format(repeatrate))
        print("Deal with it..")

    with open(SPEED_FILE, 'w') as f:
        new_line = (" ".join(xset_str) + " " + str(delay) + " " +
                    str(repeatrate) + "\n")
        f.writelines(lines[:-1] + [new_line])


def main():
    if have_days_passed(days=14):
        # only update every 14 days: typing at superhuman speed
        # is a slow process.. ;-)
        with open(LAST_UPDATED, "w") as f:
            f.write(str(datetime.date.today()))

        # Increase the current keyboard speed by decreasing the delay
        # and increasing the repeat rate when holding keys.
        # Assume some min and max values to avoid eventual disaster.
        increase_keyboard_speed(delay_increment=5, repeatrate_increment=5,
                                delay_min_value=30, repeatrate_max_value=200)
    else:
        # 14 days since last boost have not passed yet: do nothing
        exit(0)


if __name__ == "__main__":
    main()
