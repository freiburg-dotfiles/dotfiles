========
dotfiles
========

Status of automatic dotfiles installation via `setup.py`:

|Build Status|

This is a collection of my dotfiles together with ansible-based automatic installation 
facilities to allow transferring my setup quickly and painlessly to new machines. 

.. |Build Status| image:: https://travis-ci.org/MFreidank/dotfiles.svg?branch=master
   :target: https://travis-ci.org/MFreidank/dotfiles

Installation
============

Installation of tools is done using `ansible 
<http://www.ansible.com/>`_.

First, we need to install `ansible` which we can do easily using `pip`:

.. code-block:: bash

    pip install ansible

An installation of all most commonly used targets can then be done using:

.. code-block:: bash

    ansible-playbook -i dotfiles_installation/localhost_inventory.yml dotfiles_installation/install/install.yml --ask-become-pass
`ask-become-pass` is necessary to provide ansible with the ability to make system-level changes where required by the argument `become` in tasks. Not all roles might need this.

To install only a single target with its configuration, e.g. vim, simply do:

.. code-block:: bash

    ansible-playbook -i dotfiles_installation/localhost_inventory.yml dotfiles_installation/install/install.yml --tags="vim" 

To list all possible targets do: 

.. code-block:: bash

    ansible-playbook --list-tags dotfiles_installation/install/install.yml

Uninstalling a dotfile target with associated packages is also supported:

.. code-block:: bash

    ansible-playbook -i dotfiles_installation/localhost_inventory.yml dotfiles_installation/uninstall/uninstall.yml --tags="vim"
