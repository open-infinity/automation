class oi3-activemq-rdbms::service ($rdbms_bas_machine_id_list = undef, $rdbms_mysql_password = undef, $rdbms_amq_password = undef) {

	if $rdbms_bas_machine_id_list == undef {
		$_rdbms_bas_machine_id_list = $::basmachineidlist
	}
	else {
		$_rdbms_bas_machine_id_list = $rdbms_bas_machine_id_list
	}

	if $rdbms_mysql_password == undef {
		$_rdbms_mysql_password = $::mysql_password
	}
	else {
		$_rdbms_mysql_password = $rdbms_mysql_password
	}
	if $rdbms_amq_password == undef {
		$_rdbms_amq_password = $::amq_password
	}
	else {
		$_rdbms_amq_password = $rdbms_amq_password
	}

        $nodeids = parsejson($_rdbms_bas_machine_id_list)

        define amqdbcreate ($juttu = $title, $rootpass, $amqpass) {
                exec { "oi3-create-activemq-db-${juttu}":
                        unless => "/usr/bin/mysql -uroot -p$rootpass toasamq${juttu}",
                        command => "/usr/bin/mysql -uroot -p$rootpass -e \"create database toasamq${juttu}; grant all privileges on toasamq${juttu}.* to 'activemq'@'%' identified by '$amqpass'; flush privileges;\"",
                        require => Class["oi3-rdbms::service"],
               }
        }

        amqdbcreate { $nodeids:
		rootpass => $_rdbms_mysql_password,
		amqpass => $_rdbms_amq_password,
	}
}
