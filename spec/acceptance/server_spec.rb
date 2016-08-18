require 'spec_helper_acceptance'

describe 'vision_puppet::server' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS

        class vision_puppet::puppetsql (
         String $sql_user,
         String $sql_password,
        ) {}
        class vision_puppet::puppetdb (
         String $sql_user,
         String $sql_password,
         String $sql_host,
        ) {}

        class { 'vision_puppet::server':
         location   => 'vrt',
         version    => '2.4.0-1puppetlabs1',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end


  context 'package installed' do
    describe package('puppetserver') do
      it { should be_installed.with_version('2.4.0-1puppetlabs1') }
    end
  end


  context 'files provisioned' do
    describe file('/etc/puppetlabs/puppetserver/services.d/ca.cfg') do
      it { should be_file }
      it { should contain 'This file is managed by puppet' }
      its(:content) { should match (/puppetlabs.services.ca.certificate-authority-disabled-service/) }
      its(:content) { should match (/# puppetlabs.services.ca.certificate-authority-service/) }
    end
  end

end
