class myfirewall {

package { 'firewalld':
    ensure => absent,
  }

package { 'iptables-services':
 ensure => installed,
}

service { 'iptables':
 ensure  => running,
 enable  => true,
 require => Package['iptables-services'],
}

resources { "firewall":
   purge => true,
   require => [
                 Service['iptables'],
                 Package['firewalld']
               ],
}
Firewall {
    before  => Class['myfirewall::post'],
    require => Class['myfirewall::pre'],
  }

  class { ['myfirewall::pre', 'myfirewall::post']: }
  /*

   stage { 'fw_pre':  before  => Stage['main']; }
   stage { 'fw_post': require => Stage['main']; }

   class { 'myfirewall::pre':
     stage => 'fw_pre',
   }

   class { 'myfirewall::post':
     stage => 'fw_post',
   }
*/

}
