# Class: vision_puppet::masterless
# ===========================
#
# Profile to manage Puppet masterless clients.
#

class vision_puppet::masterless (

  String $puppet_conf_dir = '/etc/puppetlabs/puppet/',
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

  file { 'routes.yaml':
    ensure  => present,
    path    => "${puppet_conf_dir}/routes.yaml",
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('vision_puppet/routes-masterless.yaml.erb'),
    require => File['puppet-conf-dir'],
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
