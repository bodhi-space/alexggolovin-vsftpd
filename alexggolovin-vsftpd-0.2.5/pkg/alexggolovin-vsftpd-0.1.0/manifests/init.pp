# Class: vsftpd 
#
# This class installs and configure vsftpd service for OS local users authenticated by their system's passwords;
#
# Permissions: FTP permissions for local users: download/upload into their home foloders only;
#
# Supported OS: Ubuntu;
#
# Additional dependency puppet modules: do not required;
#
# Usage: 
#  add class {'vsftpd':} into site.pp configuration file for nodes where vsftpd server must be installed;
#  
#

class vsftpd { 

	package {'vsftpd':
		ensure => 'installed',
	}

	file {'/etc/vsftpd.conf':
		source => "puppet:///modules/vsftpd/local_enabled.conf",	
		require => Package['vsftpd'],
	}

	service {'vsftpd':
		require => Package['vsftpd'],
		enable => 'true',
		ensure => 'true',
		subscribe => File['/etc/vsftpd.conf'],
	}

}
