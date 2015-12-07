class oi4variables {
    case $::operatingsystem {
        'RedHat', 'CentOS': {
            # oi4-basic
            $cronPackageName = 'cronie'
            $cronServiceName = 'crond'

            # oi4-bas, oi4-tomee, oi4-serviceplatform
            $javaHome = "/usr/lib/jvm/jre-1.7.0-openjdk.x86_64"
            $alternativesPath = "/usr/sbin/alternatives"
            if !(defined('$javaPackageName')) {
                    $javaPackageName = 'java-1.7.0-openjdk'
            }
            $serviceProvider = 'redhat'
        
            # rdbms puppet modules
            $createMysqlDatabaseCommand = "/usr/bin/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf"
            $openInfinityConfPath = "/etc/my.cnf.d/openinfinity.cnf"
            $createMariaDbDatabaseCommand = "/root/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf"
        
            # oi4ldap
            $apachedsServiceName = "apacheds-2.0.0_M16-default"

            # apache2/httpd
            $apachePackageName = "httpd"
            $apacheInstallPackageNames = [$apachePackageName, 'mod_ssl']
            $apacheServiceName = "httpd"
            $apacheConfPath = "/etc/httpd/conf.d/"
        }
        'Ubuntu': {
            # oi4-basic
            $cronPackageName = 'cron'
            $cronServiceName = 'cron'
        
            # oi4-bas, oi4-tomee, oi4-serviceplatform
            $javaHome = "/usr/lib/jvm/java-7-openjdk-amd64"
            $alternativesPath = "/usr/bin/update-alternatives"
            if !(defined('$javaPackageName')) {
                $javaPackageName = 'openjdk-7-jdk'
            }
            $serviceProvider = 'upstart'

            # rdbms puppet modules
            $createMysqlDatabaseCommand = "/usr/bin/mysql_install_db --user=mysql --defaults-file=/etc/mysql/my.cnf"
            $openInfinityConfPath = "/etc/mysql/conf.d/openinfinity.cnf"
            $createMariaDbDatabaseCommand = "/root/mysql_install_db --user=mysql --defaults-file=/etc/mysql/my.cnf"
        
            # oi4ldap
            $apachedsServiceName = "apacheds-2.0.0-M17-default"

            # apache2/httpd
            $apachePackageName = "apache2"
            $apacheInstallPackageNames = [$apachePackageName]
            $apacheServiceName = "apache2"
            $apacheConfPath = "/etc/apache2/conf-enabled/"
        }
        default:  { fail("Unsupported operating system") }
        }
}
