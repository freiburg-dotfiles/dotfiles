#!/bin/sh
ansible-playbook -vvvv -i dotfiles_installation/test_inventory.yml dotfiles_installation/install/install.yml
ansible-playbook -vvvv -i dotfiles_installation/test_inventory.yml dotfiles_installation/uninstall/uninstall.yml
