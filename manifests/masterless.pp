# Class: vision_puppet::masterless
# ===========================
#
# Profile to manage Puppet masterless clients.
#

class vision_puppet::masterless (

  String $puppetdb_server,

  ) {

  contain ::vision_puppet::r10k
  contain ::vision_puppet::hiera
  contain ::vision_puppet::agent

  package { 'puppetdb-termini':
    ensure  => present,
    require => Apt::Source['puppetlabs']
  }

  service { 'puppet':
    ensure  => stopped,
    enable  => false,
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
