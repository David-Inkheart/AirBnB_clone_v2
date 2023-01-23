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
    number = 1 if int(number) == 0 else int(number)

    archives_local = sorted(os.listdir("versions"))
    [archives_local.pop() for i in range(number)]
    with lcd("versions"):
        [local("rm ./{}".format(a)) for a in archives_local]

    with cd("/data/web_static/releases"):
        archives_remote = run("ls -tr").split()
        archives_remote = [a for a in archives_remote if "web_static_" in a]
        [archives_remote.pop() for i in range(number)]
        [run("rm -rf ./{}".format(a)) for a in archives_remote]
