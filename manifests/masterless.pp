# Class: vision_puppet::masterless
# ===========================
#
# Profile to manage Puppet masterless clients.
#
# Parameters
# ----------
# @param puppet_conf_dir Path to Puppet config
# @param interval Puppet apply interval
# @param log_level Puppet Log level
# @param puppetdb_server Name of PuppetDB Server
#

class vision_puppet::masterless (

  String $puppet_conf_dir = '/etc/puppetlabs/puppet/',
  String $interval        = '2h',
  String $log_level       = 'notice',
  Optional[String] $puppetdb_server = undef,

  ) {

  contain ::vision_puppet::r10k
  contain ::vision_puppet::hiera
  contain ::vision_puppet::agent

  service { 'puppet':
    ensure  => stopped,
    enable  => false,
    require => Package['puppet-agent'],
  }

  file { 'puppet-conf-dir':
    ensure => directory,
    path   => $puppet_conf_dir,
  }

  file { 'puppet.conf':
    ensure  => present,
    path    => "${puppet_conf_dir}/puppet.conf",
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('vision_puppet/puppet-masterless.conf.erb'),
    require => File['puppet-conf-dir'],
  }

  # Install service for fetching module updates
  file { '/etc/systemd/system/fetch-modules.service':
    ensure  => present,
    content => template('vision_puppet/fetch-modules.service.erb'),
  }

  # Install systemd timer for puppet apply
  file { '/etc/systemd/system/apply.service':
    ensure  => present,
    content => template('vision_puppet/apply.service.erb'),
    notify  => Service['apply'],
    require => File['/etc/systemd/system/fetch-modules.service'],
  }

  file { '/etc/systemd/system/apply.timer':
    ensure  => present,
    content => template('vision_puppet/apply.timer.erb'),
    notify  => Service['apply'],
  }

  service { 'apply':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    name     => 'apply.timer',
    require  => [
      File['/etc/systemd/system/apply.service'],
      File['/etc/systemd/system/apply.timer'],
    ],
  }

  service { 'mcollective':
    ensure   => stopped,
    enable   => false,
    provider => 'systemd',
  }

  if $puppetdb_server != undef {

    file { 'puppetdb.conf':
      ensure  => present,
      path    => "${puppet_conf_dir}/puppetdb.conf",
      owner   => root,
      group   => root,
      mode    => '0744',
      content => template('vision_puppet/puppetdb-masterless.conf.erb'),
      require => File['puppet-conf-dir'],
    }

    package { 'puppetdb-termini':
      ensure  => present,
      require => Apt::Source['puppetlabs']
    }

  }

}
