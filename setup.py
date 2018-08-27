#!/usr/bin/python3
# -*- coding: iso-8859-15 -*-
import argparse
from glob import glob
import logging
import os
from os.path import dirname, expanduser, join as path_join

from dotfiles_installation.installable import Installable, get_filename
from dotfiles_installation.progressbar import progress

DOTFILES_HOME = path_join(dirname(__file__))
HOME_DIRECTORY = expanduser("~")
XDG_CONFIG = path_join(HOME_DIRECTORY, ".config")

I3_HOME = path_join(HOME_DIRECTORY, ".i3")
VIM_HOME = path_join(HOME_DIRECTORY, ".vim")
ZSH_HOME = path_join(HOME_DIRECTORY, ".zsh")

INSTALLABLES = (
    Installable(
        name="i3wm",
        pre_commands=(
            ("echo 'deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe' | sudo tee -a /tmp/t.txt"),
            ("sudo", "apt-get", "update"),
            ("sudo", "apt-get", "update"),
        ),
        apt_packages=("i3", "i3-wm"),
        configuration_installation=(
            (path_join(DOTFILES_HOME, "i3", "config"),
             path_join(I3_HOME, "config")),
            (path_join(DOTFILES_HOME, "i3", "i3status.conf"),
             path_join(I3_HOME, "i3status.conf")),
            (path_join(DOTFILES_HOME, "i3", "i3_layout_start.sh"),
             path_join(HOME_DIRECTORY, "i3_layout_start.sh")),
        )
    ),
    Installable(
        name="vim",
        apt_packages=("vim-gnome",),
        configuration_installation=(
            (path_join(DOTFILES_HOME, "vim", "vimrc"),
             path_join(HOME_DIRECTORY, ".vimrc")),
        ),
        git_clones={
            "https://github.com/VundleVim/Vundle.vim.git": path_join(VIM_HOME, "bundle", "Vundle.vim")},
        post_commands=(
            ("vim", "+PluginInstall", "+qall"),
        )
    ),
    Installable(name="cmake", apt_packages=("build-essential", "cmake",)),
    Installable(name="git", apt_packages=("git",)),
    Installable(
        name="zsh",
        apt_packages=("zsh",),
        configuration_installation=tuple(
            (configuration_path,
             path_join(ZSH_HOME, get_filename(configuration_path)))
            for configuration_path
            in glob("{}/*.zsh".format(path_join(DOTFILES_HOME, "zsh")))
        ),
        post_commands=(
            ("sudo", "usermod", "-s", "/bin/zsh", os.getenv("USER")),
            # XXX: antigen installation?
        )
    ),
    Installable(
        name="mutt",
        apt_packages=("mutt", "msmtp", "gpgsm"),
        configuration_installation=(
            (path_join(DOTFILES_HOME, "mutt", "muttrc"),
             path_join(HOME_DIRECTORY, ".muttrc")),
            (path_join(DOTFILES_HOME, "mutt", "account.google"),
             path_join(HOME_DIRECTORY, ".mutt", "account.google")),

        ),
    ),
    Installable(
        name="archive_tools",
        apt_packages=("unrar", "unzip"),
    ),
    Installable(
        name="zathura",
        apt_packages=("zathura",),
        configuration_installation=(
            (path_join(DOTFILES_HOME, "zathura", "zathurarc"),
             path_join(XDG_CONFIG, "zathura", "zathurarc")),
        ),
    ),
    Installable(name="svn", apt_packages=("subversion",)),
    Installable(name="silversearcher-ag", apt_packages=("silversearcher-ag",)),
    Installable(name="scrot", apt_packages=("scrot",)),
    Installable(name="sxiv", apt_packages=("sxiv",)),
    Installable(name="anki", apt_packages=("anki",)),
    Installable(
        name="latex",
        apt_packages=(
            "texlive",
            "texlive-lang-german",
            "texlive-latex-extra",
            "texlive-latex-base",
            "texlive-luatex",
            "texlive-xetex",
            "texlive-latex-recommended",
            "texlive-science",
            "texlive-pstricks",
            "texlive-lang-english",
            "texlive-extra-utils",
            "texlive-fonts-extra",
            "texlive-fonts-recommended",
            "texlive-fonts-utils",
            "dvipng",  # for anki
        )
    ),
    Installable(
        name="python",
        apt_packages=(
            "flake8",
            "python-dev", "python3-dev",
            "python-pip", "python3-pip",
            "bpython", "bpython3"
        ),
        configuration_installation=(
            (path_join(DOTFILES_HOME, "bpython", "config"),
             path_join(XDG_CONFIG, "bpython", "config")),
            (path_join(DOTFILES_HOME, "bpython", "foo.theme"),
             path_join(XDG_CONFIG, "bpython", "foo.theme")),
        ),
        post_commands=(
            ("sudo", "pip2", "install", "--upgrade", "pip"),
            ("sudo", "pip2", "install", "numpy"),
            ("sudo", "pip2", "install", "scipy"),
            ("sudo", "pip2", "install", "sklearn"),
            ("sudo", "pip2", "install", "sympy"),
            ("sudo", "pip3", "install", "--upgrade", "pip"),
            ("sudo", "pip3", "install", "numpy"),
            ("sudo", "pip3", "install", "scipy"),
            ("sudo", "pip3", "install", "sklearn"),
            ("sudo", "pip3", "install", "sympy"),
        )
    ),
)


def main():
    logging.basicConfig(level=2, format="%(message)s")
    parser = argparse.ArgumentParser(
        description="This script installs/uninstalls dotfiles and required packages "
                    "automatically. It supports installation of individual "
                    "targets as well as a complete installation of "
                    "all available choices. "
                    "If this is too much magic for you, you can always use "
                    "setup.py install --dryrun PACKAGE"
                    "and only installation instructions are printed to "
                    "the screen, without any actual action being taken."
    )

    subparsers = parser.add_subparsers()
    install_parser = subparsers.add_parser(
        "install",
        help="Install tools and packages.\n"
             "No additional argument defaults to `full`, "
             "which installs *all* packages and tools. "
             "To install only individual targets do `setup.py install TARGET`, "
             "see also `setup.py install --help` for a list of available targets."
    )
    # If no arguments given to "install", do "install all"
    install_parser.set_defaults(
        action=lambda dryrun: list(progress(
            (installable.install(dryrun) for installable in INSTALLABLES),
            total=len(INSTALLABLES),
            dryrun=dryrun
        )),
    )
    install_parser.add_argument(
        "--dryrun",
        help="Only print commands to execute, do not install anything.",
        action="store_true",
        default=False
    )

    uninstall_parser = subparsers.add_parser(
        "uninstall",
        help="Uninstall tools and packages.\n"
             "No additional argument defaults to `full`, "
             "which uninstalls *all* packages and tools. "
             "To uninstall only individual targets do `setup.py uninstall TARGET`, "
             "see also `setup.py uninstall --help` for a list of available targets."
    )
    uninstall_parser.add_argument(
        "--dryrun",
        help="Only print commands to execute, do not uninstall anything.",
        action="store_true",
        default=False
    )

    # If no arguments given to "uninstall", do "uninstall all"
    uninstall_parser.set_defaults(
        action=lambda dryrun: list(progress(
            (installable.uninstall(dryrun) for installable in INSTALLABLES),
            total=len(INSTALLABLES),
            dryrun=dryrun
        )),
    )

    install_subparsers = install_parser.add_subparsers()
    uninstall_subparsers = uninstall_parser.add_subparsers()

    # Install all.
    full_install_parser = install_subparsers.add_parser(
        "full", help="Install all supported and listed tools and packages."
    )
    full_install_parser.set_defaults(
        action=lambda dryrun: list(progress(
            (installable.install(dryrun) for installable in INSTALLABLES),
            total=len(INSTALLABLES),
            dryrun=dryrun
        )),
    )

    # Uninstall all.
    full_uninstall_parser = uninstall_subparsers.add_parser(
        "full", help="Uninstall all supported and listed tools and packages."
    )
    full_uninstall_parser.set_defaults(
        action=lambda dryrun: list(progress(
            (installable.uninstall(dryrun) for installable in INSTALLABLES),
            total=len(INSTALLABLES),
            dryrun=dryrun
        )),
    )

    # Install/Uninstall individual packages.
    for installable in sorted(INSTALLABLES, key=lambda installable: installable.name):
        installable_install_parser = install_subparsers.add_parser(
            installable.name, help=installable.description
        )
        installable_install_parser.set_defaults(action=installable.install)

        uninstallable_uninstall_parser = uninstall_subparsers.add_parser(
            installable.name, help=installable.description
        )
        uninstallable_uninstall_parser.set_defaults(action=installable.uninstall)

    args = parser.parse_args()

    try:
        args.action(args.dryrun)
    except AttributeError:
        parser.print_help()


if __name__ == "__main__":
    main()
