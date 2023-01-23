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

    archive_list = local("ls -t versions", capture=True).split("\n")
    archive_list_len = len(archive_list)
    for archive in archive_list[number: archive_list_len]:
        local("rm versions/{}".format(archive))

    archive_list = run("ls -t /data/web_static/releases").split("\n")
    archive_list_len = len(archive_list)
    for archive in archive_list[number: archive_list_len]:
        run("rm -rf /data/web_static/releases/{}".format(archive))
