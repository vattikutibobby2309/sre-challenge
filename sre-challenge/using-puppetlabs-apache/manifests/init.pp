class { 'apache':
}

apache::vhost { 'puppetagent_no_ssl':
  servername      => 'puppetagent',
  serveraliases   => 'localhost',
  vhost_name      => '*',
  port            => '80',
  docroot         => '/var/www/html',
  redirect_status => 'permanent',
  redirect_dest   => 'https://localhost:8443/',
}

apache::vhost { 'puppetagent_ssl':
  servername => 'puppetagent',
  serveraliases   => 'localhost',
  port       => '443',
  docroot    => '/var/www/html',
  ssl        => true,
}
include ::myfirewall
include ::mysrefile
