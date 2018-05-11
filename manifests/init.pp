# Linux local users

class users (
    String $rootpw,
    Hash $users = {},
    Hash $groups = {},
    Hash $files = {},
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

    $fdefaults = { 'show_diff' => false }
    # files and folders only in /home
    $files.each |$f, $fp| {
          if has_key($fp, 'path') {
              if $fp['path'] =~ /^\/home\// {
                  file { $f: * => $fdefaults + $fp }
              }
          } else {
              if $f =~ /^\/home\// {
                  file { $f: * => $fdefaults + $fp }
              }
          }
    }

}
