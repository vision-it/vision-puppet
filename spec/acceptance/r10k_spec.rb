require 'spec_helper_acceptance'

describe 'vision_puppet::r10k' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'vision_puppet::r10k':
         user     => 'foobar',
         password => 'foobar',
        }
      EOS

      apply_manifest(pp, :catch_failures => false)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'package installed' do
    describe package('python3-yaml') do
      it { should be_installed}
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/r10k/r10k.yaml') do
      it { should be_file }
      it { should be_mode 644 }
      its(:content) { should match 'This file is managed by puppet' }
    end

    describe file('/etc/puppetlabs/r10k/postrun.rb') do
      it { should be_file }
      it { should be_mode 755 }
    end

    describe file('/etc/puppetlabs/r10k/postrun/postrun.py') do
      it { should be_file }
      it { should be_mode 755 }
    end
  end

end
