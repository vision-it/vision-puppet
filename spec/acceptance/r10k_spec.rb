require 'spec_helper_acceptance'

describe 'vision_puppet::r10k' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-EOS
        class { 'vision_puppet::r10k':
         user     => 'foobar',
         password => 'foobar',
         remote_path_hiera  => 'hiera_path_foobar',
         remote_path_puppet => 'puppet_path_foobar',
        }
      EOS

      apply_manifest(pp, catch_failures: false) # Service needs another run
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
    describe file('/etc/puppetlabs/r10k/r10k.yaml') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'This file is managed by puppet' }
      its(:content) { is_expected.to match 'puppet_path_foobar' }
      its(:content) { is_expected.to match 'hiera_path_foobar' }
    end

    describe file('/etc/puppetlabs/r10k/postrun/postrun.py') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 755 }
    end
  end

  context 'service running' do
    describe service('webhook') do
      it { is_expected.to be_running }
    end
  end
end
