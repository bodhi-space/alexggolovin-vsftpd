####
# Class: vsftpd 
#
# This class installs and configure vsftpd service;
# OS depend parameters configured by ::vsftpd::params class; 
# vsftpd.conf for virtual and real users authentication: vsftpd.conf.erb and vsftpd_virt.conf.erb assigned via ::vsftpd::params class;
# Virtual users home folder '/home/virtual' for all users from Berkley database;
# Anonymous content folder '/var/ftp' created with help of ::vsftpd::content included class;
# Permissions: anonymous '/var/ftp' download only, local/virtual users: download/upload into their home folders only;
#
# Supported OS: Ubuntu/CentOS/RedHat, (Debian hardcoded in vsftpd.conf.erb for anonymous downloads only.); 
#
# Usage: please read README.md main vsftpd module documentation file
#  
####

class vsftpd( 
#OS depends parameters                                                                                                     
 $configdir               = $::vsftpd::params::dir,                                                                         
 $distropackage           = $::vsftpd::params::package,                                                                 
 $service_name            = $::vsftpd::params::service,                                                      
 $userdb		              = $::vsftpd::params::userdb,
 $template_realusers      = $::vsftpd::params::template_realusers,
 $template_virtusers      = $::vsftpd::params::template_virtusers,
 $dbutils		              = $::vsftpd::params::dbutils,
#Required vsftpd.conf common options configured in vsftpd.conf templates                                            
 $listen                  = 'YES',                                                                                            
 $listen_ipv6             = 'NO',                                                                                             
 $anonymous_enable        = 'YES',
 $anon_root		            = '/var/ftp',
 $anon_upload_enable	    = 'NO',
 $anon_mkdir_write_enable = 'NO',                                                                      
 $local_enable            = 'YES',                                                                                            
 $write_enable            = 'YES',                                                                                            
 $local_umask		          = '022',
 $dirmessage_enable       = 'YES',                                                                                            
 $use_localtime           = 'YES',                                                                                            
 $xferlog_enable          = 'YES',                                                                                            
 $connect_from_port_20    = 'YES',                                                                                            
 $chroot_local_user       = 'YES',                                                                                            
 $allow_writeable_chroot  = 'YES',                                                                                            
 $pasv_enable		          = 'YES',
 $pasv_min_port           = '40000',                                                                                          
 $pasv_max_port           = '60000',                                                                                          
 $rsa_cert_file           = '/etc/ssl/certs/ssl-cert-snakeoil.pem',                                                           
 $rsa_private_key_file    = '/etc/ssl/private/ssl-cert-snakeoil.key',                                                         
 $ssl_enable              = 'NO',
 $syslog_enable           = 'NO',
#Virtual users configurations:
 $enable_virtual	        = 'NO',
 $guest_enable		        = 'YES',
 $guest_username	        = 'virtual',
 $virtual_use_local_privs = 'YES',
 $ftpuser                 = hiera('ftpuser', ''),
)
inherits ::vsftpd::params { 

  package { "$distropackage":
    ensure => 'installed',
  }

  if $enable_virtual == 'NO' {
    $pam_service_name = 'vsftpd'
    
    file { "${configdir}/vsftpd.conf":
      content => template($template_realusers),
      require => Package[$distropackage],
    }
    
    case $operatingsystem {
      'RedHat',
      'CentOS': {
        exec { "selinux-systemusers":
          command => ["setsebool -P ftp_home_dir=1"],
          path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
        }
      }
    }
   }
  elsif $enable_virtual == 'YES' {
    $pam_service_name = 'vsftpd_virt'
    file {"${configdir}/vsftpd.conf":
      content => template($template_virtusers),
      require => Package[$distropackage],
    }

    package {"${dbutils}":
      ensure => installed,
    }

    file {'/etc/pam.d/vsftpd_virt':
      ensure => file,
      content => template('vsftpd/pam_ftp.erb'),
    }

    user {'virtual':
      ensure => present,
      home => '/home/virtual',
      managehome => true,
      shell => '/bin/false',
    }
  	
    file {"/home/virtual/":
      ensure => "directory",
      owner  => "virtual",
      group  => "virtual",
      mode   => 770,
      require => User['virtual'],
    }
           
    file {'/etc/vsftpd_users.txt':
      ensure => file,
      content => template('vsftpd/vsftpd_users.erb'),
    }

    exec {"db_load":
      require => File['/etc/vsftpd_users.txt'],
      path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
      command => "db_load -T -t hash -f /etc/vsftpd_users.txt /etc/vsftpd_logins.db",
    }
  	
    case $operatingsystem {
      'RedHat',
      'CentOS': {
        exec { "selinux-virtualusers":
          command => ["setsebool -P ftp_home_dir=1 && chcon -R -t public_content_rw_t /home/virtual"],
          path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
          onlyif  => "test -f /home/virtual",
        }
      }
    }

  }

  service { "$service_name":
    require => Package[$distropackage],
    enable => 'true',
    ensure => 'true',
    subscribe => File["${configdir}/vsftpd.conf"],
  }
 

include ::vsftpd::content
}
