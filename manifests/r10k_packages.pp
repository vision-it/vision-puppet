# Class: vision_puppet::r10k_packages
# ===========================
#
# Profile to manage r10k packages, since we only have Ruby 2.1
#

class vision_puppet::r10k_packages (

  $provider = 'puppet_gem',

) {

  if !defined(Package['sinatra']) {
    package { 'sinatra':
      ensure   => '1.4.8',
      provider => $provider,
    }
  }

  if !defined(Package['rack']) {
    package { 'rack':
      ensure   => '1.6.5',
      provider => $provider,
    }
  }

}
