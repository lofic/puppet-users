# Linux local users

class users (
    String $rootpw,
    Hash $users = {}
    ){

    # Not present by default on Debian systems
    group { 'wheel': ensure => present, }

    user { 'root':
        uid        => 0,
        gid        => 0,
        managehome => false,
        shell      => '/bin/bash',
        password   => $rootpw,
    }

    file { '/root/.ssh' :
          ensure  => directory,
          owner   => 'root',
          group   => 'root',
          mode    => '0700',
          require => User['root'],
    }

    $userdefaults = {
        'ensure'     => 'present',
        'groups'     => [],
        'homeprefix' => '/home',
        'shell'      => '/bin/bash',
    }

    $users.each |$u, $p| { users::user { $u: * => $userdefaults + $p } }

}
