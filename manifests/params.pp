# Class: vsftpd::params                                                                
# Description: determine vsftpd.conf file location, service and package names after OS checking;                             # 
                                                                                                                          
class vsftpd::params {

#System/Virtual user based templates
 $template_realusers = 'vsftpd/vsftpd.conf.erb'
 $template_virtusers = 'vsftpd/vsftpd_virt.conf.erb'

  #OS depend options
  case $operatingsystem {                                                                                                    
    'CentOS',                                                                                                                
    'RedHat',
    'Amazon': {                                                                                                              
      $dir = '/etc/vsftpd'
      $package = 'vsftpd'
      $service = 'vsftpd'
      $userdb = 'pam_userdb.so'
      $dbutils = 'libdb-utils'
    }
    'Debian',                                                                                             
    'Ubuntu': {                                                                                                              
      $dir = '/etc'
      $package = 'vsftpd'
      $service = 'vsftpd'                                                                                  
      $userdb = 'pam_userdb.so'
      $dbutils = 'db-util'
    }                                                                                                                        
  }                                                                                                                          
} 
