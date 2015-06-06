###Description:
 This is complex module example which allows deploy and configure vsftpd service for local system users with allowed for download and upload permissions into their own home folders, anonymous configured users restricted access for download only from '/var/ftp' folder with possible managed this folder's content by this module with next variety of supported OS: CentOS/RedHat/Debian/Ubuntu; 

###Usage:
 To change vsftpd service configurations edit vsftpd class parameters in the init.pp file, or directly templates/vsftpd.conf.erb template's file options. To get it started just add class {'vsftpd':} into site.pp configuration file for nodes where vsftpd server must be installed.
