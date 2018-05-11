# Linux local users

class users (
    String $rootpw,
    Hash $users = {},
    Hash $groups = {},
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

    $groupdefaults = { 'ensure' => 'present', }

    $users.each  |$u, $up| { users::user { $u: * => $userdefaults  + $up } }
    $groups.each |$g, $gp| { group       { $g: * => $groupdefaults + $gp } }

}
