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

  Optional[String] $pdb_class = '::vision_puppet::puppetdb',
  Optional[Integer] $pdb_port = undef,
  Optional[String] $pdb_server = undef,
  String $location = $::location,
  String $version,

) {

  package { 'puppetserver':
    ensure => $version,
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

  # In VM Puppetserver/PuppetDB/SQL get bundled
  # In Production they are separate

  if $location == 'vrt' {

    contain $pdb_class

    } else {

      if $pdb_server == undef {
        fail('PuppetDB not defined (puppet::puppetdb::host and puppet::puppetdb::port)')
      }

      class { '::puppetdb::master::config':
        puppetdb_server => $pdb_server,
        puppetdb_port   => $pdb_port,
      }

    }

}
