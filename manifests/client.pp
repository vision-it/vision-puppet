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
# @param role Role of this nod
# @param log_file Logfile of puppet agent
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
  String $role,
  String $last_run_file,

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
    ensure => present,
    source => 'puppet:///modules/vision_puppet/puppet-logrotate',
  }

  # We are not using PCP Execution Protocol (PXP)
  Service { 'pxp-agent':
    enable => false,
  }

  file { '/etc/logrotate.d/pxp-agent':
    ensure => absent,
  }

}
