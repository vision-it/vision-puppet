# vision-puppet

[![Build Status](https://travis-ci.org/vision-it/vision-puppet.svg?branch=production)](https://travis-ci.org/vision-it/vision-puppet)

## Parameters

### Puppet Server
##### String `vision_puppet::server:version`
No default. (Example: '2.4.0-1puppetlabs1)

### Puppet Agent
##### String `vision_puppet::client:puppet_server`
No default.
##### String `vision_puppet::client:interval`
Interval for Puppet Agent runs - default '6h'
##### String `vision_puppet::client:log_file`
Destination of logs for (background) Puppet Agent runs
##### String `vision_puppet::client:role`
Role of this node (required for checking if this is a Puppet Server or not)
##### Optional[Boolean] `vision_puppet::client:pin`
Enables Pinning of Puppet Agent version in apt. Defaults to false.
##### Optional[String] `vision_puppet::client:pin_version`
Sets the pinned version in apt
##### Optional[Integer] `vision_puppet::client:pin_priority`
Sets the pinning priority in apt. Defaults to 1000.


### PuppetDB
##### String `vision_puppet::puppetdb::sql_user`
No default.
##### String `vision_puppet::puppetdb::sql_password`
No default.
##### String `vision_puppet::puppetdb::sql_host`
Default: 'localhost'.
##### String `vision_puppet::puppetdb::listen_address`
Default: '0.0.0.0'

### r10k
##### String `vision_puppet::r10k::user`
No default. The User who is running the r10k webhook.
##### String `vision_puppet::r10k::password`
No default.

## Usage
Use of the Puppetdb in the Dev environment
```puppet
class { '::vision_puppet::puppetsql':
  sql_user     => 'puppetdb',
  sql_password => 'puppetdb',
}
class { '::vision_puppet::puppetdb':
  sql_user     => 'puppetdb',
  sql_password => 'puppetdb',
  sql_host     => 'localhost',
  require      => Class['::vision_puppet::puppetsql'],
}
```

## Installation

Include in the *Puppetfile*:

```
mod vision_puppet:
    :git => 'https://github.com/vision-it/vision-puppet.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_puppet::puppetdb
```
