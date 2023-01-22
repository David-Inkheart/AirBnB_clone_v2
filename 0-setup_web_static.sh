#!/usr/bin/env bash
# Install a nginx web server listening on port 80.
#
# configures a brand new Ubuntu machine
# to the requirements asked in this task
#
# Configure Nginx so that its HTTP response contains
# a custom header

# Update package list
sudo apt-get update -y

# if the following don't already exist, install/create
[ ! -f /usr/sbin/nginx ] && sudo apt-get install -y nginx
sudo ufw allow 'Nginx HTTP'

[ ! -d /data/web_static/releases/test/ ] && sudo mkdir -p /data/web_static/releases/test/
[ ! -d /data/web_static/shared/ ] && sudo mkdir -p /data/web_static/shared/

# fake HTML file with simple content, to test your Nginx configuration
echo "<!DOCTYPE html>
<html>
	<head>
	</head>
	<body>
		<p>Hey People<p>
	</body>
</html>" | sudo tee /data/web_static/releases/test/index.html

# If the symbolic link already exists, it should be deleted
# and recreated every time the script is ran.
[ -f /data/web_static/current ] && sudo rm /data/web_static/current
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# assign Recursive ownership of '/data/' to 'ubuntu' USER and GROUP
sudo chown -R "ubuntu:ubuntu" /data/

# Update the Nginx configuration to serve the content of /data/web_static/current/
# to hbnb_static (ex: https://mydomainname.tech/hbnb_static)
head_of_loc="location \/hbnb\_static\/ {"
content="alias \/data\/web\_static\/current\/;"
location="\n\t$head_of_loc\n\t\t$content\n\t}\n"
sed -i "37s/$/$location/" /etc/nginx/sites-available/default

# Restart nginx without using systemctl
sudo service nginx restart
