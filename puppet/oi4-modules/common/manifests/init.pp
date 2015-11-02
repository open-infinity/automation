class common {
  file {"/opt":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => 755,
  }
  
  file {"/opt/openinfinity":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt"]],
  }

  file {"/opt/openinfinity/data":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt/openinfinity"]],
  }

  file {"/opt/openinfinity/log":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt/openinfinity"]],
  }

  file {"/opt/openinfinity/conf":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt/openinfinity"]],
  }

  file {"/opt/openinfinity/lib":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt/openinfinity"]],
  }

  file {"/opt/openinfinity/common":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 644,
    require => [User["oiuser"], File["/opt/openinfinity"]],
  }

  file {"/home/oiuser":
    ensure  => directory,
    owner   => 'oiuser',
    group   => 'oiuser',
    mode    => 750,
    require => [User['oiuser'],Group['oiuser']]
  }

  user { "oiuser":
    ensure     => present,
    comment    => "Open Infinity user",
    gid        => "oiuser",
    shell      => "/bin/bash",
    managehome => true,
    require    => Group["oiuser"],
  }

  group {"oiuser":
    ensure => present,
  }
}
