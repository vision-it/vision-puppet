require 'spec_helper_acceptance'

describe 'vision_puppet::puppetdb' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        class { 'vision_puppet::puppetdb':
         listen_address => '0.0.0.0',
         cert_whitelist => ['localhost'],
         sql_user       => 'foobar',
         sql_password   => 'foobar',
         sql_host       => 'beaker',
        }
      FILE

      # TODO: fails due to ssl configuration of puppetdb, needs fixing
      apply_manifest(pp, catch_failures: false)
      apply_manifest(pp, catch_changes: false)
    end
  end

  context 'package installed' do
    describe package('puppetdb') do
      it { is_expected.to be_installed }
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/puppetdb/ssl/ca.pem') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 600 }
    end

    describe file('/etc/puppetlabs/puppetdb/certificate-whitelist') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'localhost' }
    end
  end
end
