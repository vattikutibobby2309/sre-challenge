class myfirewall::post {
/*
   firewall { "999 drop all other requests":
     action => "drop",
   }
*/
   firewall { '999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }

 }
