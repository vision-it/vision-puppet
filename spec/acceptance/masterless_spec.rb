require 'spec_helper_acceptance'

describe 'vision_puppet::masterless' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        package { 'unzip':
          ensure => present,
        }
        class { 'vision_puppet::masterless':
          puppet_conf_dir => '/data',
        }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'files provisioned' do
    describe file('/data/puppet.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 744 }
      it { is_expected.to contain 'facts_terminus = facter' }
      it { is_expected.to contain 'This file is managed by puppet' }

      it { is_expected.not_to contain 'storeconfigs = true' }
      it { is_expected.not_to contain 'storeconfigs_backend = puppetdb' }
    end

    describe file('/data/routes.yaml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'apply:' }
      it { is_expected.to contain 'terminus: facter' }
      it { is_expected.to contain 'cache: yaml' }

      it { is_expected.not_to contain 'terminus: compiler' }
      it { is_expected.not_to contain 'cache: puppetdb' }
      it { is_expected.not_to contain 'cache: puppetdb_apply' }
    end

    describe file('/etc/apt/preferences.d/puppet-agent.pref') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'This file is managed by Puppet. DO NOT EDIT.' }
      it { is_expected.to contain 'Package: puppet-agent' }
      it { is_expected.to contain 'Pin: version 1.2.3' }
      it { is_expected.to contain 'Pin-Priority: 999' }
    end

    describe package('puppet-agent') do
      it { is_expected.to be_installed }
    end

    describe service('puppet') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
