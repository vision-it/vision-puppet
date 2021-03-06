# Class: vision_puppet::agent
# ===========================
#
# Profile to manage Puppetlabs agent package
#
# Parameters
# ----------
# @param repo_key Apt Repo Key
# @param repo_key_id Apt Repo Key ID
# @param repo_component Apt Repo Name
# @param pin Pin Puppet Version (bool)
# @param pin_version Apt Version to pin
# @param pin_priority Apt Pin Priority
#

class vision_puppet::agent (

  String $repo_key,
  String $repo_key_id,
  String $repo_component,
  Optional[Boolean] $pin          = undef,
  Optional[String] $pin_version   = undef,
  Optional[Integer] $pin_priority = undef,

) {

  apt::source { 'puppetlabs':
    location => 'https://apt.puppetlabs.com',
    repos    => $repo_component,
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

}
