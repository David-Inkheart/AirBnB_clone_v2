#!/usr/bin/python3
"""
generates a .tgz archive from the contents of the web_static folder
of my AirBnB Clone repo, using the function do_pack
"""
from datetime import datetime
from fabric.api import local
import os


def do_pack():
    """Generates a .tgz archive from the contents
    of the web_static folder of this repository.
    """
    if not os.path.exists("versions"):
        os.mkdir("versions")

    date_time = datetime.now().strftime("%Y%m%d%H%M%S")
    archive_name = "web_static_{}.tgz".format(date_time)
    archive_path = "versions/{}".format(archive_name)

    local("tar -cvzf {} web_static".format(archive_path))

    if os.path.exists(archive_path):
        return archive_path
    return None
