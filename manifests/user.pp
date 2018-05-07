# Macro for creating a user

define users::user (
    $uid,
    $gid,
    String $ensure,
    String $password,
    String $shell,
    $groups,
    String $homeprefix,
    $user=$title) {

    group { $user:
        ensure => present,
        gid    => $gid,
    }

    user { $user :
        ensure     => $ensure,
        uid        => $uid,
        gid        => $gid,
        managehome => true,
        home       => "${homeprefix}/${user}",
        password   => $password,
        shell      => $shell,
        membership => 'inclusive',
        groups     => $groups,
        require    => Group[$user],
    }

    file { "${homeprefix}/${user}/.ssh" :
      ensure  => directory,
      owner   => $user,
      group   => $user,
      mode    => '0700',
      require => User[$user]
    }

    file { "${user} scripts folder" :
        ensure  => directory,
        path    => "${homeprefix}/${user}/scripts",
        owner   => $user,
        group   => $user,
        mode    => '0755',
        require => User[$user]
    }

    file { "vimcustom.sh ${user}" :
        ensure  => present,
        path    => "${homeprefix}/${user}/scripts/vimcustom.sh",
        source  => 'puppet:///modules/users/vimcustom.sh',
        owner   => $user,
        group   => $user,
        mode    => '0755',
        require => File["${user} scripts folder"],
    }


}
