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
  String $g10k_url      = 'https://github.com/xorpaul/g10k/releases/download/v0.5.8/g10k-linux-amd64.zip',
  String $g10k_checksum = '1fee326742e6c90efb23683cbc0063b7dfbdbe1b5a91a98990036a70d5563a33',

) {

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

}
