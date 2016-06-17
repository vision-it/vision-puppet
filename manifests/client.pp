# Class: vision_puppet::client
# ===========================
#
# Profile to manage Puppet client.
#
# Parameters
# ----------
#
# @param puppet_server Name of puppet master
# @param interval Interval of puppet run
# @param role Role of this node
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::client
#

class vision_puppet::client (

  String $puppet_server,
  String $interval,
  String $role,

) {

  service { 'puppet':
    hasrestart => true,
  }

  file { '/etc/default/puppet/':
    ensure  => present,
    content => template('vision_puppet/puppet-cl-args.erb'),
    notify  => Service['puppet'],
  }

  file { '/etc/logrotate.d/puppet':
    ensure  => present,
    content => template('vision_puppet/puppet.erb'),
  }

  if $role != 'puppetserver' {
    file { '/etc/puppetlabs/puppet/puppet.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0744',
      content => template('vision_puppet/puppet4.conf.erb'),
      notify  => Service['puppet'],
    }
  }

  # We are not using PCP Execution Protocol (PXP)
  Service { 'pxp-agent':
    enable => false,
  }

  file { '/etc/logrotate.d/pxp-agent':
    ensure => absent,
  }

}
