# Class: vision_puppet::server
# ===========================
#
# Profile to manage Puppet server.
# Notice, the Puppet server also gets configured during bootstrap
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::server
#

class vision_puppet::server (

  String $version,
  Integer $pin_priority,
  String $location               = $::location,
  Optional[Integer] $pdb_port    = undef,
  Optional[String] $pdb_server   = undef,
  Optional[Integer] $report_days = 30,

) {

  package { 'puppetserver':
    ensure  => present,
    require => File['/etc/apt/preferences.d/puppetserver'],
  }

  file { '/etc/apt/preferences.d/puppetserver':
    ensure  => present,
    owner   => root,
    group   => root,
    content => "# This file is managed by Puppet; DO NOT EDIT
Package: puppetserver
Pin: version ${version}
Pin-Priority: ${pin_priority}
"
  }

  file { '/etc/puppetlabs/puppetserver/services.d/':
    ensure  => directory,
    require => Package['puppetserver'],
  }

  file { '/etc/puppetlabs/puppetserver/services.d/ca.cfg':
    ensure  => present,
    source  => 'puppet:///modules/vision_puppet/ca.cfg',
    require => File['/etc/puppetlabs/puppetserver/services.d/'],
  }

  file { '/etc/cron.d/puppetserver-delete-reports':
    ensure  => present,
    content => "# Warning: This file is managed by puppet;
    31 1 * * root /usr/bin/find /opt/puppetlabs/server/data/puppetserver/reports/ -mtime ${report_days} -type f -delete
    ",
    mode    => '0740',
  }

  # Virtual Puppetserver/PuppetDB/SQL get bundled, in productio they are separate
  if $location == 'vrt' {

    class { '::vision_puppet::puppetsql':
      sql_user     => 'puppetdb',
      sql_password => 'puppetdb',
    }

    class { '::vision_puppet::puppetdb':
      sql_user     => 'puppetdb',
      sql_password => 'puppetdb',
      sql_host     => 'localhost',
      require      => Class['::vision_puppet::puppetsql'],
    }

  } else {

    if $pdb_server == undef {
      fail('PuppetDB not defined')
    } else {

      class { '::puppetdb::master::config':
        puppetdb_server => $pdb_server,
        puppetdb_port   => $pdb_port,
      }
    }
  }

}
