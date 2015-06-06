# Class: vsftpd::params                                                                
# Description: determine vsftpd.conf file location, service and package names after OS checking;                             # 
                                                                                                                          
class vsftpd::params{

  case $operatingsystem {                                                                                                    
    'CentOS',                                                                                                                
    'RedHat': {                                                                                                              
      $dir = '/etc/vsftpd'
      $package = 'vsftpd'
      $service = 'vsftpd'
    }
    'Debian',                                                                                             
    'Ubuntu': {                                                                                                              
      $dir = '/etc'
      $package = 'vsftpd'
      $service = 'vsftpd'                                                                                  
    }                                                                                                                        
  }                                                                                                                          
} 
