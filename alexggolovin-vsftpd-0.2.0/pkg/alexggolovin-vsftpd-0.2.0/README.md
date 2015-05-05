#### Table of Contents

2. [Description](#description)
3. [Classes](#classes)
4. [Folders](#folders)
5. [Permissions](#permissions)
5. [Supported OS](#supported_os)
6. [Usage](#usage)
7. [Hiera Examples](#hiera_examples)



###Description:
  This is complex module example which allows deploy and configure vsftpd service for virtual or local system users with allowed for download and upload permissions into their own home folders, anonymous configured users restricted access for download only from '/var/ftp' folder with possible managed this folder's content by this module with next variety of supported OS: CentOS/RedHat/Ubuntu/Debian.
 
### Classes 

-Class  vsftpd
 This class installs and configure vsftpd service;

-Class ::vsftpd::params 
This class responsible for OS depend parameters and vsftpd.conf configuration file options.
For virtual and real users authentication: vsftpd.conf.erb and vsftpd_virt.conf.erb assigned via ::vsftpd::params class;

###Folders
-Virtual users home folder '/home/virtual' for all users from Berkley database;

-Anonymous content folder '/var/ftp' created with help of ::vsftpd::content included class;
 
###Permissions: 
Anonymous '/var/ftp' download only, local/virtual users: download/upload into their home folders only;

###Supported OS: 
Ubuntu/CentOS/RedHat, (Debian hardcoded in vsftpd.conf.erb for anonymous downloads only, because of Debian build package doesn't works with "allow_writeable_chroot" option );

###Usage:
 To change vsftpd service configurations edit vsftpd class parameters like "$listen" in the init.pp file, or add/remove required options in templates/vsftpd.conf.erb for real system's users and templates/vsftpd_virt.conf.erb for virtual user's configuration files. To get it started just add class {'vsftpd':} into site.pp configuration file for nodes where vsftpd server must be installed.

 1.Add class {'vsftpd':} into site.pp configuration file for nodes where vsftpd server must be installed

 2.Real system users authentication usage configured by default via init.pp class parameter "$enable_virtual = 'NO'".

 3.If you want to change default system authentication to virtual users authentication you have to: 

  3.1 To be sure hiera is installed on your puppet master server, usually it's already installed by default as a part of puppet;

  3.2 Add new "-vsftpd" hierarchy in /etc/puppet/hiera.yaml
      Example:
      ---
       :backends:
        - yaml
       :yaml:
        :datadir: /etc/puppet/hiera
       :hierarchy:
        -vsftpd

  3.3 Configure your hiera datasource with required user/password values for Berkley DB:
      Example: /etc/puppet/hiera/vsftpd.yaml user,password,user,password line by line;
      ---
       vsftpd::ftpuser:
        - alex
        - mytopsecretpass
        - mike
        - mikespasssecret

  3.4 Change init.pp class parameter "$enable_virtual = 'NO'" to "$enable_virtual = 'YES'"

  3.5 Security notes: don't forget to change your /etc/puppet/hiera/vsftpd.yaml secret password file access permissions.


###Hiera Examples:
  hiera_examples module folder contains:
    hiera.yaml - hiera configuration file example;
    vsftpd.yaml - virtual users usernames and passwords database example;



