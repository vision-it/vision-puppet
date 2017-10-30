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
# @param log_file Logfile of puppet agent
# @param pin enables or disables APT Pinning of Puppet Agent package
# @param pin_version version to be APT pinned
# @param pin_priotity priority of pinned Puppet Agent package
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::client
#

class vision_puppet::client (

  String $interval,
  String $log_file,
  String $puppet_server,
  String $role                    = hiera('role'),
  Optional[Boolean] $pin          = undef,
  Optional[String] $pin_version   = undef,
  Optional[Integer] $pin_priority = undef,

) {

  service { 'puppet':
    hasrestart => true,
  }

  file { '/etc/default/puppet':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_puppet/puppet-args.conf.erb'),
    notify  => Service['puppet'],
  }

  if $role != 'puppetserver' {
    file { '/etc/puppetlabs/puppet/puppet.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0744',
      content => template('vision_puppet/puppet.conf.erb'),
      notify  => Service['puppet'],
    }
  }

  file { '/etc/logrotate.d/puppet':
    ensure  => present,
    content => file('vision_puppet/puppet-logrotate'),
  }

  # We are not using PCP Execution Protocol (PXP)
  Service { 'pxp-agent':
    enable => false,
  }

  file { '/etc/logrotate.d/pxp-agent':
    ensure => absent,
  }

  # If requested, enable pining of puppet agent
  if $pin {
    file { '/etc/apt/preferences.d/puppet-agent':
      ensure  => present,
      owner   => root,
      group   => root,
      content => "# This file is managed by Puppet; DO NOT EDIT
Package: puppet-agent
Pin: version ${pin_version}
Pin-Priority: ${pin_priority}
"
    }
  }

}
