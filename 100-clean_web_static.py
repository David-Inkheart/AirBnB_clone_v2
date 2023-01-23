#!/usr/bin/python3
"""
deletes out-of-date archives
"""
from fabric.api import *
import os

env.hosts = ['35.153.52.152', '54.160.77.140']


def do_clean(number=0):
    """
    Deletes out-of-date archives
    """
    if number < 1:
        number = 1

    with lcd("versions"):
        local_files = local("ls -td web_static_*", capture=True)
        local_files_list = local_files.split()
        out_of_date_local_files = local_files_list[number:]

        for file in out_of_date_local_files:
            local("rm -f {file}".format(file=file))

    with cd("/data/web_static/releases"):
        remote_folders = run("ls -td web_static_*")
        remote_folders_list = remote_folders.split()
        out_of_date_remote_folders = remote_folders_list[number:]

        for folder in out_of_date_remote_folders:
            run("rm -rf {folder}".format(folder=folder))
