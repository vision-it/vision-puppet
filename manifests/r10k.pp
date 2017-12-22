# Class: vision_puppet::r10k
# ===========================
#
# Profile to manage r10k, but we're using g10k now
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

  String $remote_path_hiera,
  String $remote_path_puppet,
  String $g10k_url      = 'https://github.com/xorpaul/g10k/releases/download/v0.4.4/g10k-linux-amd64.zip',
  String $g10k_checksum = 'e5a2ec0e6da4d2fd579c93cda97b55c922b56f4b888bba6a2f9b174bd28eeb66',

) {

  archive { '/tmp/g10k.zip' :
    ensure        => present,
    source        => $g10k_url,
    checksum      => $g10k_checksum,
    checksum_type => 'sha256',
    extract_path  => '/opt/puppetlabs/bin',
    extract       => true,
    require       => File['/etc/puppetlabs/r10k'],
  }

  # Deploy Config
  file { '/etc/puppetlabs/r10k':
    ensure => 'directory',
  }

  file { '/etc/puppetlabs/r10k/g10k.yaml':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_puppet/r10k.yaml.erb'),
    require => File['/etc/puppetlabs/r10k'],
  }

  # Python Postrun Script to manage Custom Modules in Vagrant
  package { 'python3-yaml':
    ensure => 'present',
  }

  vcsrepo { '/etc/puppetlabs/r10k/postrun':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/vision-it/postrun.git',
    revision => 'master'
  }

}
