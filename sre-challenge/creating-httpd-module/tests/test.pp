class { 'httpd':
}

httpd::vhost { 'puppetagent':
  servername => 'puppetagent',
  docroot    => '/var/www/html',
  port            => '80',
  redirect_ssl => true,
  redirect_ssl_site => 'https://puppetagent:8443',
  ssl_port       => '443',
  ssl        => true,
}
