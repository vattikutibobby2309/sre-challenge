class mysrefile (
  $docroot = $::apache::params::docroot,
  $user = $::apache::params::user,
  $group = $::apache::params::group,
){
  include apache::params
  file { "${docroot}/index.html":
      ensure => 'present',
      mode => '0755',
      owner => "$user",
      group => "$group",
      content => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\n<html><head><title>SRE Challenge</title></head><body><h1>SRE Challenge</h1></body></html>\n",
      before => Service['httpd'],
  }
}
