# Class: httpd
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#

class httpd inherits ::httpd::params{

  package { 'httpd':
    ensure => installed,
    name   => $httpd::params::apache_name,
  }

  service { 'httpd':
    ensure    => running,
    name      => $httpd::params::apache_name,
    enable    => true,
    start   => "/usr/sbin/apachectl restart", #workaround for the puppet cannot restart the service
    stop    => "/usr/sbin/apachectl stop",
    status    => "/usr/sbin/apachectl status",
    restart => "/usr/sbin/apachectl restart",
    subscribe => Package['httpd'],
  }
}
