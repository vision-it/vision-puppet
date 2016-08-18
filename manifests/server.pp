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
