# Class: vision_puppet::puppetsql
# ===========================
#
# Profile to manage Puppet Postgres
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_puppet::puppetsql
#

class vision_puppet::puppetsql (

  String $listen_address,
  String $sql_password,
  String $sql_user,

) {

  class { '::puppetdb::database::postgresql':
    database_username => $sql_user,
    database_password => $sql_password,
    listen_addresses  => $listen_address,
  }

}