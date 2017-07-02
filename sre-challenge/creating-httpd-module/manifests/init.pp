class { 'httpd':
}

httpd::vhost { 'localhost':
  servername => 'localhost',
  docroot    => '/var/www/html',
  port            => '80',
  redirect_ssl => true,
  redirect_ssl_site => 'https://localhost:8443',
  ssl_port       => '443',
  ssl        => true,
}
