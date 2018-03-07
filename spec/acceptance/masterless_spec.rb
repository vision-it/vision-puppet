require 'spec_helper_acceptance'

describe 'vision_puppet::masterless' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        class { 'vision_puppet::masterless':
         puppetdb_server => 'http://localhost:8081/',
        }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/puppet/puppet.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 744 }
      it { is_expected.to contain 'storeconfigs = true' }
      it { is_expected.to contain 'storeconfigs_backend = puppetdb' }
      it { is_expected.to contain 'facts_terminus = puppetdb' }
      it { is_expected.to contain 'This file is managed by puppet' }
    end

    describe file('/etc/puppetlabs/puppet/puppetdb.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'server_urls = http://localhost:8081/' }
      it { is_expected.to contain 'MANAGED BY PUPPET' }
    end

    describe file('/etc/puppetlabs/puppet/routes.yaml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'terminus: puppetdb' }
      it { is_expected.to contain 'cache: yaml' }
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

    describe package('puppetdb-termini') do
      it { is_expected.to be_installed }
    end

    describe service('puppet') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
