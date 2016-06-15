# Class: vsftpd 
#
# This class installs and configure vsftpd service;
#
# OS depend parameters configured by ::vsftpd::params class, template options added as parameters for vsftpd class; 
#
# Permissions: anonymous '/var/ftp' download only, local users: download/upload into their home foloders only;
#
# Supported OS: Ubuntu/CentOS/RedHat, (Debian hardcoded in vsftpd.conf.erb for anonymous downloads only :-].); 
# 
# Anonymous content example '/var/ftp/welcome.txt' file created with help of ::vsftpd::content included class;
#
# Usage: 
#  add class {'vsftpd':} into site.pp configuration file for nodes where vsftpd server must be installed;
#  
#

class vsftpd( 
#OS depends parameters                                                                                                     
 $configdir              = $::vsftpd::params::dir,                                                                         
 $distropackage          = $::vsftpd::params::package,                                                                 
 $service_name           = $::vsftpd::params::service,                                                      
#Required vsftpd.conf options configured in template                                                                        
 $template               = 'vsftpd/vsftpd.conf.erb',                                                                  
 $listen                 = 'YES',                                                                                            
 $listen_ipv6            = 'NO',                                                                                             
 $anonymous_enable       = 'YES',
 $anon_root		 = '/var/ftp',
 $anon_upload_enable	 = 'NO',
 $anon_mkdir_write_enable= 'NO',                                                                      
 $local_enable           = 'YES',                                                                                            
 $write_enable           = 'YES',                                                                                            
 $dirmessage_enable      = 'YES',                                                                                            
 $use_localtime          = 'YES',                                                                                            
 $xferlog_enable         = 'YES',                                                                                            
 $connect_from_port_20   = 'YES',                                                                                            
 $chroot_local_user      = 'YES',                                                                                            
 $allow_writeable_chroot = 'YES',                                                                                            
 $pasv_min_port          = '40000',                                                                                          
 $pasv_max_port          = '60000',                                                                                          
 $pam_service_name       = 'vsftpd',                                                                                         
 $rsa_cert_file          = '/etc/ssl/certs/ssl-cert-snakeoil.pem',                                                           
 $rsa_private_key_file   = '/etc/ssl/private/ssl-cert-snakeoil.key',                                                         
 $ssl_enable             = 'NO',                                                                                             
                                                                                                                             
) inherits ::vsftpd::params { 

	package {$distropackage:
		ensure => 'installed',
	}

	file {"${configdir}/vsftpd.conf":
                content => template($template),
		require => Package['vsftpd'],
	}

	service {$service_name:
		require => Package[$distropackage],
		enable => 'true',
		ensure => 'true',
		subscribe => File["${configdir}/vsftpd.conf"],
	}

include ::vsftpd::content

}
