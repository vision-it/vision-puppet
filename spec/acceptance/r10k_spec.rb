require 'spec_helper_acceptance'

describe 'vision_puppet::r10k' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        package { 'unzip': ensure => 'present' }

        class { 'vision_puppet::r10k':
         remote_path_hiera  => 'hiera_path_foobar',
         remote_path_puppet => 'puppet_path_foobar',
        }
      FILE
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'package installed' do
    describe package('python3-yaml') do
      it { is_expected.to be_installed }
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/r10k/g10k.yaml') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'This file is managed by puppet' }
      its(:content) { is_expected.to match 'puppet_path_foobar' }
      its(:content) { is_expected.to match 'hiera_path_foobar' }
      its(:content) { is_expected.to match 'puppetfilelocation' }
    end

    describe file('/etc/puppetlabs/r10k/postrun/postrun.py') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 755 }
    end
    describe file('/opt/puppetlabs/bin/g10k') do
      it { is_expected.to be_file }
    end
  end
end
