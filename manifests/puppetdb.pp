# Class: vision_puppet::puppetdb
# ===========================
#
# Profile to manage PuppetDB
#
# Parameters
# ----------
#
# @param password Webhook password
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::puppetdb
#

class vision_puppet::puppetdb (

  Array $cert_whitelist = [ $::servername ],
  String $listen_address,
  String $sql_host,
  String $sql_password,
  String $sql_user,

) {

  $cert_path = '/etc/puppetlabs/puppetdb/ssl'
  $cert_file = "${cert_path}/ca.pem"

  file { [  '/etc/puppetlabs/puppetdb', $cert_path ]:
    ensure => 'directory',
  }->
  exec { 'vision.crt':
    refreshonly => true,
    command     => "/bin/cp /vision/pki/VisionCA.crt ${cert_file}",
  }->
  file { $cert_file:
    ensure  => present,
    owner   => puppetdb,
    group   => puppetdb,
    mode    => '0600',
    require => Package['puppetdb'],
  }

  # Configure the Puppet Master to use puppetdb.
  if $sql_host == 'localhost' {
    include ::puppetdb::master::config
  }

  class { '::puppetdb::server':
    database_host         => $sql_host,
    database_username     => $sql_user,
    database_password     => $sql_password,
    listen_address        => $listen_address,
    certificate_whitelist => $cert_whitelist,
    node_ttl              => '7d',
    node_purge_ttl        => '7d',
    java_args             => {
      '-Xmx' => '256m',
    },
  }

}
