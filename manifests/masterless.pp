# Class: vision_puppet::masterless
# ===========================
#
# Profile to manage Puppet masterless clients.
#

class vision_puppet::masterless (

  String $puppetdb_server,
  String $repo_key,
  String $repo_key_id,
  String $role                    = lookup('role', String, 'first', 'default'),
  Optional[Boolean] $pin          = undef,
  Optional[String] $pin_version   = undef,
  Optional[Integer] $pin_priority = undef,

  ) {

  contain ::vision_puppet::r10k
  contain ::vision_puppet::hiera

  apt::source { 'puppetlabs':
    location => 'https://apt.puppetlabs.com',
    repos    => 'main',
    key      => {
      id      => $repo_key_id,
      content => $repo_key,
    },
    include  => {
      'src' => false,
      'deb' => true,
    }
  }

  if $pin {
    apt::pin { 'puppet-agent':
      packages => 'puppet-agent',
      priority => $pin_priority,
      version  => $pin_version,
    }
  }

  package { 'puppet-agent':
    ensure  => present,
    require => Apt::Source['puppetlabs']
  }

  package { 'puppetdb-termini':
    ensure  => present,
    require => Apt::Source['puppetlabs']
  }

  service { 'puppet-agent':
    ensure  => stopped,
    require => Package['puppet-agent'],
  }

  file { '/etc/puppetlabs/puppet/puppet.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('vision_puppet/puppet-masterless.conf.erb'),
  }

  file { '/etc/puppetlabs/puppet/puppetdb.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('vision_puppet/puppetdb-masterless.conf.erb'),
  }

  file { '/etc/puppetlabs/puppet/routes.yaml':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('vision_puppet/routes.yaml'),
  }

}
