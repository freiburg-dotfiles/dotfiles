import logging
from os import makedirs, remove
from os.path import dirname, split as path_split
import shutil
from subprocess import check_call, CalledProcessError
from shutil import copy


def color_cyan(text):
    cyan = '\033[0;36m'
    no_color = '\033[0m'
    return "{cyan}{text}{no_color}".format(cyan=cyan, text=text, no_color=no_color)


def color_red(text):
    red = '\033[0;36m'
    no_color = '\033[0m'
    return "{red}{text}{no_color}".format(red=red, text=text, no_color=no_color)


def log_info(text, dryrun):
    if not dryrun:
        logging.info(color_cyan(text))


def log_error(text):
    logging.error(color_red(text))


def execute_command(command, dryrun):
    if isinstance(command, str):
        command_str = command
    else:
        command_str = " ".join(command)

    logging.debug("{} command: '{}'".format(
        "Dryrunning" if dryrun else "Executing", command_str
    ))

    if dryrun:
        print(command_str)
    else:
        try:
            check_call(command_str, shell=True)
            logging.debug("Command '{}' executed without error.".format(command_str))
        except CalledProcessError as e:
            log_error(
                "ERROR -- Command failed: '{}'\n"
                "Error was: {}".format(command_str, str(e))
            )


def get_filename(path):
    logging.debug("Determining file name for path: '{}'".format(path))
    _, filename = path_split(path)
    logging.debug("File name is: {}".format(filename))
    return filename


def apt_install(package, dryrun):
    logging.debug("{} package '{}' using apt.".format(
        "Dryrunning installation of" if dryrun else "Installing", package
    ))
    execute_command(
        ("sudo", "apt-get", "install", package, "-y", "--force-yes"),
        dryrun
    )


def apt_uninstall(package, dryrun):
    logging.debug("{} package '{}' using apt.".format(
        "Dryrunning purge of" if dryrun else "Purging", package
    ))
    execute_command(
        ("sudo", "apt-get", "purge", package, "-y", "--force-yes"),
        dryrun
    )


def git_clone(url, target_location, dryrun):
    if dryrun:
        logging.debug("Dryrun directory creation for git clone target.")
        logging.debug("Git clone target directory is: '{}'".format(
            dirname(target_location))
        )
        print("mkdirs", "-p", dirname(target_location))
    else:
        try:
            logging.debug("Attemption to create target directory for git clone.")
            logging.debug("Git clone target directory is: '{}'".format(
                dirname(target_location))
            )
            makedirs(dirname(target_location))
        except FileExistsError:
            logging.debug("Directory already exists.")
            pass
    logging.debug(
        "{} from url '{}' to local target location '{}'".format(
            "Dryrunning 'git clone'" if dryrun else "Git-cloning",
            url,
            target_location
        )
    )
    execute_command(("git", "clone", url, target_location), dryrun)


class Installable(object):
    def __init__(self,
                 name,
                 description=None,
                 pre_commands=None,
                 apt_packages=None,
                 configuration_installation=None,
                 git_clones=None,
                 post_commands=None,):
        self.name = name
        self.description = description if description is not None else ""
        self.apt_packages = apt_packages if apt_packages is not None else []

        self.pre_commands = pre_commands if pre_commands is not None else []

        if configuration_installation is not None:
            self.configuration_installation = configuration_installation
        else:
            self.configuration_installation = []

        self.git_clones = git_clones if git_clones is not None else {}
        self.post_commands = post_commands if post_commands is not None else []

    def install(self, dryrun):
        log_info("Installing {}...".format(self.name), dryrun)

        logging.debug("Processing pre-commands:")
        for command in self.pre_commands:
            execute_command(command, dryrun)

        logging.debug("Processing apt installations:")
        for package in self.apt_packages:
            apt_install(package, dryrun=dryrun)

        logging.debug("Installing configurations files:")
        for configuration_location, configuration_target in self.configuration_installation:
            logging.debug(
                "Installing configuration file from path '{}' to "
                "target path '{}'".format(configuration_location, configuration_target)
            )
            if dryrun:
                print("mkdir", "-p", dirname(configuration_target))
            else:
                try:
                    makedirs(dirname(configuration_target))
                except FileExistsError:
                    pass

            if dryrun:
                print("cp", configuration_location, configuration_target)
            else:
                copy(configuration_location, configuration_target)

        logging.debug("Processing git commands:")
        for repository_url, target_location in self.git_clones.items():
            git_clone(repository_url, target_location=target_location, dryrun=dryrun)

        logging.debug("Processing post-commands:")
        for command in self.post_commands:
            execute_command(command, dryrun)

        log_info("Done.", dryrun)

    def uninstall(self, dryrun):
        log_info("Uninstalling {}...".format(self.name), dryrun)

        logging.debug("Processing apt uninstallations:")
        for package in self.apt_packages:
            apt_uninstall(package, dryrun=dryrun)

        logging.debug("Removing configuration files:")
        for _, configuration_target in self.configuration_installation:
            logging.debug(
                "Removing configuration file at location '{}'.".format(
                    configuration_target
                )
            )
            if dryrun:
                print("rm", configuration_target)
            else:
                remove(configuration_target)

        logging.debug("Removing cloned git repositories..")
        for _, target_location in self.git_clones.items():
            if dryrun:
                logging.debug("Dryrunning removal of git repository at '{}'.".format(
                    target_location)
                )
                print("rm", "-rf", target_location)
            else:
                logging.debug("Removing git repository at '{}'.".format(target_location))
                shutil.rmtree(target_location, ignore_errors=True)

        log_info("Done.", dryrun)
