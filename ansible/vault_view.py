#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import yaml
from ansible.cli import CLI
from ansible.parsing.vault import VaultEditor

PARSER = argparse.ArgumentParser()
PARSER.add_argument("-f", "--file",
            help="Display all vault variables from a yaml file",
            required=True,
            type=argparse.FileType('r'))
ARGS = PARSER.parse_args()

class LoadAnsibleYaml(object):

    def __init__(self):
        self.vault_pass = CLI.ask_vault_passwords()
        self.vault_editor = VaultEditor(self.vault_pass)
        
        def vault_constructor(loader, tag_suffix, node):
            return self.vault_editor.vault.decrypt(node.value)
        yaml.add_multi_constructor('!vault', vault_constructor)

    def load(self, file):
        self.file = yaml.load(file)

    def pretty_print(self):
        print '-------------'
        print yaml.dump(self.file, default_flow_style = False)

if __name__ == "__main__":

    loader = LoadAnsibleYaml()
    loader.load(ARGS.file)
    loader.pretty_print()
