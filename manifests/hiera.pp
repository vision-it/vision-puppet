# Class: vision_puppet::hiera
# ===========================
#
# Profile to manage Hiera.
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::hiera
#

class vision_puppet::hiera {

  file { '/etc/puppetlabs/puppet/hiera.yaml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0744',
      content => file('vision_puppet/hiera.yaml'),
    }

  file { '/etc/puppetlabs/code/hiera.yaml':
    ensure => link,
    target => '/etc/puppetlabs/puppet/hiera.yaml',
  }

}
