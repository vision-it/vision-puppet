# vision-puppet

[![Build Status](https://travis-ci.org/vision-it/vision-puppet.svg?branch=production)](https://travis-ci.org/vision-it/vision-puppet)

## Parameters

### Puppetdb
##### String `vision_puppet::puppetdb::sql_user`
No default.
##### String `vision_puppet::puppetdb::sql_password`
No default.
##### String `vision_puppet::puppetdb::sql_host`
Default: 'localhost'.
##### String `vision_puppet::puppetdb::listen_address`
Default: '0.0.0.0'

## Usage
Include of the Puppetdb in the Dev environment
```puppet
class { '::vision_puppet::puppetdb':
  sql_user     => 'puppetdb',
  sql_password => 'puppetdb'
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

