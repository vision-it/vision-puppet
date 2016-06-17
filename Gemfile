source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['>= 3.3']
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'
if RUBY_VERSION < '2.2'
    gem 'rspec', ' < 3.2'
else
    gem 'rspec', '>= 3.4'
end
gem 'rake', ' < 10.0'
gem 'beaker', github: 'puppetlabs/beaker', branch: 'master'
gem 'pry'
gem 'beaker-rspec'
gem 'beaker_spec_helper'
gem 'serverspec'
