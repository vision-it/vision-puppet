# Class: vision_puppet::keys
# ===========================
#
# Profile to manage SSH keys for Puppet repos
#
# Parameters
# ----------
# @param public_key SSH Public Key
# @param private_key SSH Private Key
# @param hosts Hosts for Template
# @param identityfile Path to SSH Key

class vision_puppet::keys (

  String $public_key,
  String $private_key,
  Array[Hash] $hosts,
  String $identityfile = '/root/.ssh/puppetdeploy',

) {

  file { $identityfile:
    ensure  => present,
    owner   => 'root',
    mode    => '0600',
    content => $private_key,
  }

  file { "${identityfile}.pub":
    ensure  => present,
    owner   => 'root',
    mode    => '0600',
    content => $public_key,
  }

  file { '/root/.ssh/config':
    ensure  => present,
    owner   => 'root',
    mode    => '0644',
    content => template('vision_puppet/ssh_config.erb'),
  }

}
