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
# contain ::vision_puppet::client
#

class vision_puppet::hiera (

){

  class { '::hiera':
    merge_behavior  => 'deeper',
    backends        => ['yaml', 'eyaml'],
    datadir         => '/etc/puppetlabs/code/hieradata/%{environment}',
    hierarchy       => [
      'node/%{::clientcert}',
      'location/%{::location}/%{applicationtier}',
      'location/%{::location}/common',
      'tier/%{applicationtier}/%{role}',
      'tier/%{applicationtier}',
      'role/%{role}',
      'type/%{::nodetype}',
      'type/common',
      'users',
      'common',
    ],
    eyaml           => true,
    eyaml_extension => 'yaml',
    eyaml_datadir   => '/etc/puppetlabs/code/hieradata/%{environment}',
    create_keys     => false,
  }

  file { '/etc/puppetlabs/code/hiera.yaml':
    ensure => link,
    target => '/etc/puppetlabs/puppet/hiera.yaml',
  }

}
