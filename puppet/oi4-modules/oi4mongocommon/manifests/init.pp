
#
# This is a work-around to Puppet dependency limitations, when more than one
# oi3mongo modules are installed in the same host. The same seems to apply
# to the overlapping directories.
#

class oi3mongocommon {
    package { ['mongodb-org-server']:
        ensure => present,
    }

    package { ['mongodb-org-mongos']:
        ensure => present,
    }
    
    package { ['mongodb-org-shell']:
        ensure => present,
    }
    
    # Directories to be created
    $mongo_directories = [
#        "/opt/openinfinity",
#        "/opt/openinfinity/log",
        "/opt/openinfinity/log/mongodb",
#        "/opt/openinfinity/data",
#        "/opt/openinfinity/service",
        "/opt/openinfinity/service/mongodb",
        "/opt/openinfinity/service/mongodb/scripts",
    ]
    file { $mongo_directories:
        ensure => "directory",
        owner => 'mongod',
        group => 'mongod',
        mode => 0755,
        require => [
            File["/opt/openinfinity/log"],     # defined in oi3-basic
            File["/opt/openinfinity/data"],    # defined in oi3-basic
            File["/opt/openinfinity/service"], # defined in oi3-basic
            ],
    }
}

