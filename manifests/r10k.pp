# Class: vision_puppet::r10k
# ===========================
#
# Profile to manage r10k, but we're using g10k now
# https://github.com/xorpaul/g10k

class vision_puppet::r10k(

  String $remote_path_hiera,
  String $remote_path_puppet,
  String $g10k_url      = 'https://github.com/xorpaul/g10k/releases/download/v0.8.7/g10k-linux-amd64.zip',
  String $g10k_checksum = '7250465ea2d78452a46950ed94a19aa89f218502d17d3c434d6b2af8e06ea399',

  ) {

  contain ::vision_puppet::keys

  # Temporary cause of duplicate resource with sys
  # if !defined(Package['unzip']) {
  #   package { 'unzip':
  #     ensure => present,
  #   }
  # }

  file { '/etc/puppetlabs/r10k':
    ensure => 'directory',
  }

  archive { '/tmp/g10k.zip' :
    ensure        => present,
    source        => $g10k_url,
    checksum      => $g10k_checksum,
    checksum_type => 'sha256',
    extract_path  => '/opt/puppetlabs/bin',
    extract       => true,
    require       => [
      File['/etc/puppetlabs/r10k']
    ],
  }

  file { '/etc/puppetlabs/r10k/g10k.yaml':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_puppet/r10k.yaml.erb'),
    require => File['/etc/puppetlabs/r10k'],
  }

  file { '/usr/local/bin/g10k':
    ensure => absent,
  }

}
