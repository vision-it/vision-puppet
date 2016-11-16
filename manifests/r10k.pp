# Class: vision_puppet::r10k
# ===========================
#
# Profile to manage R10K
#
# Parameters
# ----------
#
# @param user Webhook user
# @param password Webhook password
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::r10k
#

class vision_puppet::r10k(

  String $user,
  String $password,

) {

  class { '::r10k::webhook::config':
    use_mcollective => false,
    enable_ssl      => false,
    user            => $user,
    pass            => $password,
  }

  class { '::r10k::webhook':
    use_mcollective => false,
    user            => root,
    group           => 0,
    require         => Class['::r10k::webhook::config'],
  }

  file { '/etc/puppetlabs/r10k':
    ensure => 'directory',
  }

  # New
  vcsrepo { '/etc/puppetlabs/r10k/postrun':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/vision-it/postrun.git',
    require  => Class['::r10k::webhook::config'],
    revision => 'master',
  }

  # Legacy
  file { '/etc/puppetlabs/r10k/postrun.rb':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///modules/vision_puppet/postrun.rb',
    require => Class['::r10k::webhook::config'],
  }

}
