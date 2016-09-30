class oi4idp::provision()
{
  include oi4idp::params
  include oi4idp::tomcat_service

  $idp_install_path="${oi4idp::params::idp_install_path}"
  $sp_provisioning_host="${oi4idp::params::sp_provisioning_host}"

  exec { "download sp metadata":
    command     => "/usr/bin/wget http://$sp_provisioning_host:8889/sp-metadata.xml -O $idp_install_path/metadata/sp-metadata.xml",
    creates     => "$idp_install_path/metadata/sp-metadata.xml",
  }
  file { "$idp_install_path/metadata/sp-metadata.xml":
    owner => "oiuser",
    group => root,
    require => Exec["download sp metadata"],
    notify => Service["oi-tomcat-service"]
  }


  # if ($idp_master_ip_address != $idp_node_ip_address){
  #   # Copy all configuration data from master
  #   # TODO optimize:
  #   #   - minimalize list of files to transfer
  #   #   - don't configure files by puppet if they will be overwritten by rsync
  #   exec { "copy_master_metadata":
  #     command     => "/root/shibboleth-idp/bin/install.sh",
  #     cwd         => "rsync -v -a /opt/shibboleth-idp/metadata/ root@$idp_master_ip_address:/opt/shibboleth-idp/metadata/",
  #     require => File["${idp_install_path}"],
  #     notify      => Service["oi-tomcat"]
  #   }
  # }
}

#class oi4idp::config::jstl{
#  wget::fetch { "download jstl":
#    source      => "http://tecdevpm1.dev.teco.local//modules/op/4.5/jbossliferaypatching/files/${$liferay_patchingtool_filename}",
#    destination => "${platform_home}/${$liferay_patchingtool_filename}",
#    timeout     => 0,
#    verbose     => false,
#    require     => Class["jbossliferayportal_ee::config"],
#  }
#  file { "jstl":
#    path    => "/opt/shibboleth-idp/edit-webapp/WEB/lib/jstl-1.2.jar",
#    source  => "puppet:///modules/oi4idp/metadata_providers.xml",
#    ensure  => present,
#    owner   => 'oiuser',
#    group   => 'root',
#    mode    => 0640,
#    require => File["$idp_install_path"],
#  } ->
#  exec { "rebuild war with jstl":
#    command => "/opt/shibboleth-idp/bin/build.sh",
#  } ->
#  file { "new war owners":
#    path    => "/opt/shibboleth-idp/war/idp.war",
#    source  => "puppet:///modules/oi4idp/metadata_providers.xml",
#    ensure  => present,
#    owner   => 'oiuser',
#    group   => 'root',
#    mode    => 0600,
#  }
#}

# class oi4idp::config::sp{
#   file { "/opt/shibboleth-idp/conf/metadata-providers.xml":
#     ensure  => present,
#     owner   => 'oiuser',
#     group   => 'root',
#     mode    => 0640,
#     source  => "puppet:///modules/oi4idp/metadata_providers.xml",
#     require => File["$idp_install_path"],
#     notify  => Service["oi-tomcat"]
#   }

