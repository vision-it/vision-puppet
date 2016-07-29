# vision-puppet

[![Build Status](https://travis-ci.org/vision-it/vision-puppet.svg?branch=production)](https://travis-ci.org/vision-it/vision-puppet)

## Parameters

### `vision_puppet::puppetdb`
##### `vision_puppet::puppetdb::sql_user`
##### `vision_puppet::puppetdb::sql_password`


## Usage

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

