include stdlib

# Update package lists
exec { 'Update lists':
    command => '/usr/bin/apt update'
}

# Install the nginx package
package { 'nginx':
  ensure => 'installed',
}

# Define the firewall rule for Nginx HTTP traffic
firewall { '100 allow Nginx HTTP':
  proto  => 'tcp',
  port   => '80',
  action => 'accept',
}

# Create the required directories
file { '/data/web_static/releases/test':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

file { '/data/web_static/shared':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Create a fake HTML file in the test directory
file { '/data/web_static/releases/test/index.html':
  ensure  => 'file',
  content => "<!DOCTYPE html>

<html>

  <head>

  </head>

  <body>

    <p>Hey People<p>

  </body>

</html>",
}

# Create a symbolic link between /data/web_static/current and /data/web_static/releases/test/
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test/',
}

# Update the Nginx configuration to serve the content of /data/web_static/current/
# to hbnb_static (ex: https://mydomainname.tech/hbnb_static)

file { '/etc/nginx/sites-available/default':
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  notify => Service['nginx'],
  content => template('module/config.erb'),
}

# Restart nginx
service { 'nginx':
  ensure => running,
  enable => true,
}
