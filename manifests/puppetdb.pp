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

  Array $cert_whitelist = [$::servername],
  String $listen_address,
  String $sql_database,
  String $sql_password,
  String $sql_user,

) {

  exec { 'vision.crt':
    refreshonly => true,
    command     => '/bin/cp /vision/pki/VisionCA.crt /etc/puppetlabs/puppetdb/ssl/ca.pem',
  }

  file { '/etc/puppetlabs/puppetdb/ssl/ca.pem':
    ensure  => present,
    owner   => puppetdb,
    group   => puppetdb,
    mode    => '0600',
    require => Exec['vision.crt'],
  }

  # Configure the Puppet Master to use puppetdb.
  if $sql_database == 'localhost' {
    include ::puppetdb::master::config
  }

  class { '::puppetdb::server':
    database_host         => $sql_database,
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
