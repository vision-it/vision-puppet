require 'spec_helper_acceptance'

describe 'vision_puppet::server' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pre = <<-FILE
        package { 'unzip':
          ensure => present,
        }
        # Stretch workaround
        file { '/etc/apt/sources.list.d/puppet5.list':
          ensure  => present,
          content => 'deb http://apt.puppetlabs.com stretch puppet5',
        }
      FILE
      apply_manifest(pre, catch_failures: false)

      # Workaround cause of systemd
      if os[:release].to_i == 8
        pp = <<-FILE
                class { 'vision_puppet::server':
                      }
                FILE
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
      if os[:release].to_i == 9
        pp = <<-FILE
                 class { 'vision_puppet::server':
                         version => '5.3.7-1stretch'
                      }
                FILE
        apply_manifest(pp, catch_failures: false)
        apply_manifest(pp, catch_changes: false)
      end
      if os[:release].to_i == 10
        pp = <<-FILE
                 class { 'vision_puppet::server':
                      }
                FILE
        apply_manifest(pp, catch_failures: false)
        apply_manifest(pp, catch_changes: false)
      end
    end
  end

  context 'package installed' do
    describe package('puppetserver') do
      if os[:release].to_i == 8
        it { is_expected.to be_installed.with_version('2.4.0-1puppetlabs1') }
      end
      if os[:release].to_i == 9
        it { is_expected.to be_installed.with_version('5.3.7-1stretch') }
      end
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
    describe file('/etc/apt/preferences.d/puppetserver') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Package: puppetserver' }
      it { is_expected.to contain 'Pin: version' }
      it { is_expected.to contain 'Pin-Priority: 999' }
    end
  end
end
