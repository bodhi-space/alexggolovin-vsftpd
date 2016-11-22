# Class: vsftpd::content
# Adding required content into '/var/ftp' folder for next anonymous downloads

class vsftpd::content {

   file {'/var/ftp':                                                                                                         
    ensure => directory,                                                                                                     
    mode => "755",                                                                                                             
    owner => root,                                                                                                           
   }                                                                                                                         
                                                                                                                             
   file {'/var/ftp/welcome.txt':                                                                                             
    ensure => present,                                                                                                       
    mode => "755",                                                                                                             
    owner => root,                                                                                                           
    source => "puppet:///modules/vsftpd/welcome.txt",                                                              
    require => File['/var/ftp'],                                                                                             
   }                                                                                                                         
}
