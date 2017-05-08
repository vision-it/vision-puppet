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
  String $remote_path_hiera,
  String $remote_path_puppet,

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
  -> file { '/etc/puppetlabs/r10k/r10k.yaml':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_puppet/r10k.yaml.erb'),
  }
  -> package { 'python3-yaml':
    ensure => 'present',
  }

    # New
  vcsrepo { '/etc/puppetlabs/r10k/postrun':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/vision-it/postrun.git',
    require  => Class['::r10k::webhook::config'],
    revision => 'master',
  }

}
