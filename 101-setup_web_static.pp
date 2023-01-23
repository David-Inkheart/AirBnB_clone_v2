include stdlib

# Update package lists
exec { 'update_package_lists':
    command => '/usr/bin/apt update'
}

# Install Nginx
package { 'nginx':
    ensure  => 'present',
    require => Exec['update_package_lists']
}

# Create the directory tree
exec { 'create_directory_tree':
    command => '/bin/mkdir -p /data/web_static/releases/test /data/web_static/shared',
    require => Package['nginx']
}

$head_content = "  <head>\n  </head>"
$body_content = "  <body>\n    Hey People\n  </body>"
$index_content = "<html>\n${head_content}\n${body_content}\n</html>\n"

# Create a fake HTML file with simple content,
# to test Nginx configuration
file { 'create_fake_html':
    ensure  => 'present',
    path    => '/data/web_static/releases/test/index.html',
    content => $index_content,
    require => Exec['create_directory_tree']
}

# Create a symbolic link '/data/web_static/current' linked to the
# '/data/web_static/releases/test/' folder.
file { 'create_symbolic_link':
    ensure  => 'link',
    path    => '/data/web_static/current',
    force   => true,
    target  => '/data/web_static/releases/test',
    require => File['create_fake_html']
}

# Set permissions for 'ubuntu' user
exec { 'set_permissions':
    command => '/bin/chown -R ubuntu:ubuntu /data',
    require => File['create_symbolic_link']
}

# Set a new location for a Nginx VHost 
$location_header='location /hbnb_static/ {'
$location_content='alias /data/web_static/current/;'
$new_location="\n\t${location_header}\n\t\t${location_content}\n\t}\n"

# Write the new location to the default Nginx VHost
file_line { 'set_nginx_location':
    ensure  => 'present',
    path    => '/etc/nginx/sites-available/default',
    after   => 'server_name \_;',
    line    => $new_location,
    notify  => Service['nginx'],
    require => Exec['set_permissions']
}

# Ensure that Nginx is running
service { 'nginx':
    ensure  => 'running',
    enable  => true,
    require => Package['nginx']
}

