


class { 'apache':
}

apache::vhost { 'puppetagent non-ssl':
  servername      => 'puppetagent',
  port            => '80',
  docroot         => '/var/www/html',
  redirect_status => 'permanent',
  redirect_dest   => 'https://puppetagent:8443/',
}

apache::vhost { 'puppetagent ssl':
  servername => 'puppetagent',
  port       => '443',
  docroot    => '/var/www/html',
  ssl        => true,
}
include ::myfirewall
include ::mysrefile
