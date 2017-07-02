# Class: httpd::params
#
# This class manages Apache parameters
#
# Parameters:
# - The $user that Apache runs as
# - The $group that Apache runs as
# - The $apache_name is the name of the package and service on the relevant
#   distribution
# - The $ssl_package is the name of the Apache SSL package
# Actions:
#
# Requires:
#
# Sample Usage:
#
class httpd::params {
  if $servername == undef {
    if($::fqdn) {
      $servername = $::fqdn
    } else {
      $servername = $::hostname
    }
  }

  $user                 = 'apache'
  $group                = 'apache'
  $auth          = false
  $port          =undef
  $ssl_port          =undef
  if $ssl_public_port == undef {
      $ssl_public_port = $ssl_port
  }
  $docroot          =undef
  $server_root          = '/etc/httpd'
  $conf_dir          = "${server_root}/conf"
  $confd_dir          = "${server_root}/conf.d"
  $pidfile              = 'run/httpd.pid'
  $redirect_ssl  = false
  $redirect_ssl_site= "https://${servername}:${ssl_public_port}"
  $ssl           = true
  $ssl_conf_template      = 'httpd/ssl.conf.erb'
  $conf_template      = 'httpd/httpd.conf.erb'
  $vhost_name    = '*'

  case $::operatingsystem {
    'centos', 'redhat', 'fedora', 'scientific': {
      $apache_name = 'httpd'
      $ssl_package = 'mod_ssl'
    }
  }
}
