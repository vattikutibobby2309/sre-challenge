class { 'apache':
}

apache::vhost { 'puppet non-ssl':
  servername      => 'puppet',
  port            => '80',
  docroot         => '/var/www/redirect',
  redirect_status => 'permanent',
  redirect_dest   => 'https://puppet/'
}

apache::vhost { 'puppet ssl':
  servername => 'puppet',
  port       => '443',
  docroot    => '/var/www/redirect',
  ssl        => true,
}
