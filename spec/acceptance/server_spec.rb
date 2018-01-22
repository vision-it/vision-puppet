require 'spec_helper_acceptance'

describe 'vision_puppet::server' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        class { 'vision_puppet::server':
         location     => 'vrt',
         version      => '2.4.0-1puppetlabs1',
         pin_priority => 999,
        }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'package installed' do
    describe package('puppetserver') do
      it { is_expected.to be_installed.with_version('2.4.0-1puppetlabs1') }
    end
  end

  context 'cronjob installed' do
    describe file('/etc/cron.d/puppetserver-delete-reports') do
      it { is_expected.to be_file }
      it { is_expected.to contain '# Warning: This file is managed by puppet' }
      it { is_expected.to contain 'reports' }
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/puppetserver/services.d/ca.cfg') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'This file is managed by puppet' }
      its(:content) { is_expected.to match 'puppetlabs.services.ca.certificate-authority-disabled-service' }
      its(:content) { is_expected.to match '# puppetlabs.services.ca.certificate-authority-service' }
    end

    describe file('/etc/apt/preferences.d/puppetserver') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Package: puppetserver' }
      it { is_expected.to contain 'Pin: version 2.4.0-1puppetlabs1' }
      it { is_expected.to contain 'Pin-Priority: 999' }
    end
  end
end
