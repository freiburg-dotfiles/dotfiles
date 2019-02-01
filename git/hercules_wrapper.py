#!/usr/bin/python3
# -*- coding: iso-8859-15 -*-
from subprocess import check_call
import argparse


def install_hercules():
    raise NotImplementedError()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "repository_url", help="Url of repository to analyze."
    )

    args = parser.parse_args()

    check_call((
        "hercules", "--burndown", "--burndown-files", "--burndown-people",
        "--couples", "--shotness", args.repository_url
    ))


if __name__ == "__main__":
    main()
