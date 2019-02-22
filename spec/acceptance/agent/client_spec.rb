require 'spec_helper_acceptance'

describe 'vision_puppet::client' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        class { 'vision_puppet::client': }
      FILE

      # Workaround cause of systemd
      if os[:release].to_i == 8
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
      if os[:release].to_i != 8
        apply_manifest(pp, catch_failures: false)
        apply_manifest(pp, catch_changes: false)
      end
    end
  end

  context 'files provisioned' do
    describe file('/etc/default/puppet') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to contain 'This file is managed by puppet' }
      it { is_expected.to contain '/var/log/puppetlabs/puppet/agent.log' }
    end

    describe file('/etc/puppetlabs/puppet/puppet.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 744 }
      it { is_expected.to contain 'lastrunfile = /opt/puppetlabs/puppet/last_run_summary.yaml' }
      it { is_expected.to contain 'This file is managed by puppet' }
    end

    describe file('/etc/logrotate.d/puppet') do
      it { is_expected.to be_file }
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
      # it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
