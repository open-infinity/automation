include stdlib

#$threshold_warn_max_jvm_committed = 1000000 * floor($jvmmem * 0.75 * 0.95)  
$threshold_warn_max_jvm_committed = 1
class oi3-healthmonitoring::config { 
  if  ($toasPlatform == 'bas' or $toasPlatform == 'sp'){
     notify{"Installing monitoring bas extras":}
     $threshold_warn_max_jvm_committed = 1000000 * floor($jvmmem * 0.75 * 0.95) 
     file { "/opt/openinfinity/3.1.0/healthmonitoring/collectd/etc/collectd.conf":
        ensure => file,
        owner => 'collectd',
        group => 'collectd',
        mode => 0644,
        content => template("oi3-healthmonitoring/collectd.bas.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
      }
      file { "/opt/openinfinity/3.1.0/healthmonitoring/collectd/etc/collectd.d/threshold.conf":
        ensure => file,
        owner => 'collectd',
        group => 'collectd',
        mode => 0644,
        content => template("oi3-healthmonitoring/threshold.bas.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
      }
    }
    elsif ($toasPlatform == 'rdbms'){
      notify{"Installing monitoring rdbms extras":}
      file { "/opt/openinfinity/3.1.0/healthmonitoring/collectd/etc/collectd.conf":
        ensure => file,
        owner => 'collectd',
        group => 'collectd',
        mode => 0644,
        content => template("oi3-healthmonitoring/collectd.rdbms.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
     }
      file { "/opt/openinfinity/3.1.0/healthmonitoring/collectd/etc/collectd.d/threshold.conf":
        ensure => file,
       owner => 'collectd',
       group => 'collectd',
       mode => 0644,
       content => template("oi3-healthmonitoring/threshold.rdbms.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
      }
    }
   else{
     notify{"Installing deafult monitoring configuration":}
      file { "/opt/openinfinity/3.1.0/healthmonitoring/collectd/etc/collectd.conf":
        ensure => file,
       owner => 'collectd',
       group => 'collectd',
       mode => 0644,
       content => template("oi3-healthmonitoring/collectd.conf.erb"),
       require => Class["oi3-healthmonitoring::install"],
      }
      file { "/opt/openinfinity/3.1.0/healthmonitoring/collectd/etc/collectd.d/threshold.conf":
        ensure => file,
        owner => 'collectd',
        group => 'collectd',
        mode => 0644,
        content => template("oi3-healthmonitoring/threshold.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
      }
    }
    file { "/etc/sudoers.d/nodechecker":
        owner   => 'root',
        group   => 'root',
        mode    => 0440,
        ensure  => present,
        content => template("oi3-healthmonitoring/nodechecker.sudoers.erb"),
        require => Class["oi3-healthmonitoring::install"],
    }

    file { "/opt/openinfinity/3.1.0/healthmonitoring/nodechecker/etc/nodechecker.conf":
        owner => 'nodechecker',
        group => 'nodechecker',
        mode => 0744,
        content => template("oi3-healthmonitoring/nodechecker.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
    }
 
    file { "/opt/openinfinity/3.1.0/healthmonitoring/nodechecker/etc/nodelist.conf":
        ensure => file,
        owner => 'nodechecker',
        group => 'nodechecker',
        mode => 0744,
        content => template("oi3-healthmonitoring/nodelist.conf.erb"),
        require => Class["oi3-healthmonitoring::install"],
    }

    file { "/opt/openinfinity/3.1.0/healthmonitoring/nodechecker/var/lib/notifications/inbox":
        mode => 0777,
        require => Class["oi3-healthmonitoring::install"],
    }

    file { "/opt/openinfinity/3.1.0/healthmonitoring/nodechecker/var/lib/notifications/sent":
        mode => 0777,
        require => Class["oi3-healthmonitoring::install"],
    }
}
