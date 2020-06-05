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
          log_level => 'debug',
          interval => '42h 11m',
        }
      FILE

      # Systemd not available
      apply_manifest(pp, catch_failures: false)
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

    describe file('/etc/systemd/system/apply.service') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'This file is managed by Puppet' }
      it { is_expected.to contain '[Unit]' }
      it { is_expected.to contain 'Requires=local-fs.target' }
      it { is_expected.to contain '[Service]' }
      it { is_expected.to contain 'Type=oneshot' }
      it { is_expected.to contain 'SuccessExitStatus=0 2' }
      it { is_expected.to contain 'ExecStart=' }
      it { is_expected.to contain 'apply' }
      it { is_expected.to contain '--detailed-exitcodes' }
      it { is_expected.to contain '--log_level debug' }
      it { is_expected.to contain '[Install]' }
      it { is_expected.to contain 'WantedBy=multi-user.target' }
    end

    describe file('/etc/systemd/system/apply.timer') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'This file is managed by Puppet' }
      it { is_expected.to contain '[Unit]' }
      it { is_expected.to contain '[Timer]' }
      it { is_expected.to contain 'OnUnitActiveSec=42h 11m' }
      it { is_expected.to contain '[Install]' }
      it { is_expected.to contain 'WantedBy=timers.target' }
    end

    describe service('puppet') do
      it { is_expected.not_to be_running }
    end
  end
end
