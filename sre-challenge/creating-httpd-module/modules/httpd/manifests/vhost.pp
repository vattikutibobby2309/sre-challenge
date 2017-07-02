# Definition: httpd::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on for http://
# - The $docroot provides the DocumentationRoot variable
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $configure_firewall option is set to true or false to specify if
#   a firewall should be configured.
# - The $server_root specify the httpd configure root dir ex: /etc/httpd
# - The $pidfile is the name of the run pid file
# - The $user is the user which will run the httpd process
# - The $group is the group which will run the httpd process
# - The $ssl_port is the port for the ssl will listen to
# - The $ssl_public_port is the port which will be mapped to externally for the $ssl_port within docker container
# - The $servername is the virtual hostname
# - The $redirect_ssl specifies if redirect to ssl for standard port 80.
# - The $redirect_ssl_site is the https url the http will be redirected to
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The httpd class
#
# Sample Usage:
# httpd::vhost { 'localhost':
#  servername => 'localhost',
#  docroot    => '/var/www/html',
#  port            => '80',
#  redirect_ssl => true,
#  redirect_ssl_site => 'https://localhost:443',
#  ssl_port       => '443',
#  ssl        => true,
# }
#
#
define httpd::vhost(
    $configure_firewall = true,
    $ssl                = $httpd::params::ssl,
    $server_root                = $httpd::params::server_root,
    $pidfile                = $httpd::params::pidfile,
    $user                  = $httpd::params::user,
    $group                = $httpd::params::group,
    $ssl_port                = $httpd::params::ssl_port,
    $ssl_public_port                = $httpd::params::ssl_public_port,
    $servername      = $httpd::params::servername,
    $port            = $httpd::params::port,
    $docroot         = $httpd::params::docroot,
    $redirect_ssl = $httpd::params::redirect_ssl,
    $redirect_ssl_site   = $httpd::params::redirect_ssl_site,

  ) {

  include ::httpd

  if $ssl == true {
    include ::httpd::ssl
    include ::myfirewall
  }

  file { "httpd.conf":
      path    => "$httpd::params::conf_dir/httpd.conf",
      content => template($httpd::params::conf_template),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      purge   => true,
      force   => true,
      require => Package['httpd'],
      notify  => Service['httpd'],
      before  => Service['httpd'],
  }
  file { 'ssl.conf':
    purge   => true,
    force   => true,
    path    => "${httpd::params::confd_dir}/ssl.conf",
    content => template($httpd::params::ssl_conf_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
    before  => Service['httpd'],
  }

  file { "${docroot}/index.html":
    ensure => 'present',
    mode => '0755',
    owner => "$user",
    group => "$group",
    content => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\n<html><head><title>SRE Challenge</title></head><body><h1>SRE Challenge</h1></body></html>\n",
    before => Service['httpd'],
  }
}
