require 'spec_helper_acceptance'

describe 'vision_puppet::puppetdb' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'vision_puppet::puppetdb':
         listen_address => '0.0.0.0',
         cert_whitelist => ['localhost'],
         sql_user       => 'foobar',
         sql_password   => 'foobar',
         sql_database   => 'beaker',
        }
      EOS

      apply_manifest(pp, :catch_failures => false)
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'package installed' do
    describe package('puppetdb') do
      it { should be_installed }
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/puppetdb/ssl/ca.pem') do
      it { should be_file }
      it { should be_mode 600 }
    end

    describe file('/etc/puppetlabs/puppetdb/certificate-whitelist') do
      it { should be_file }
      it { should contain 'localhost'}
    end
  end

end
