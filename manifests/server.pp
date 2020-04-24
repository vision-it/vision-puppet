# Class: vision_puppet::server
# ===========================
#
# Profile to manage Puppet server.
# Notice, the Puppet server also gets configured during bootstrap
#
# Parameters
# ----------
# @param version Apt Version for Puppet Server
# @param pin_priority Apt Pin priority
# @param report_days Days to keep reports
# @param pdb_server PuppetDB Path
# @param pdb_port PuppetDB Port
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
  Integer $pdb_port,
  String $location             = $::location,
  Integer $report_days         = 30,
  Optional[String] $pdb_server = undef

) {

  package { 'puppetserver':
    ensure  => present,
    require => File['/etc/apt/preferences.d/puppetserver'],
  }

  # Pinning for Puppetserver Version
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
    content => file('vision_puppet/ca.cfg'),
    require => File['/etc/puppetlabs/puppetserver/services.d/'],
  }

  file { '/etc/cron.d/puppetserver-delete-reports':
    ensure  => present,
    content => "# Warning: This file is managed by puppet;
    31 1 * * root /usr/bin/find /opt/puppetlabs/server/data/puppetserver/reports/ -mtime ${report_days} -type f -delete
    ",
    mode    => '0740',
  }

  # Virtual Puppetserver/PuppetDB/SQL get bundled, in production they are separate
  if $pdb_server != undef {
    class { '::puppetdb::master::config':
      puppetdb_server => $pdb_server,
      puppetdb_port   => $pdb_port,
    }
  }
}
