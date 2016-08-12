require 'spec_helper_acceptance'

describe 'vision_puppet::client' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'vision_puppet::client':
         puppet_server => 'localhost',
         role          => 'beaker',
         log_file      => '/var/log/puppetlabs/puppet/agent.log',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'files provisioned' do
    describe file('/etc/default/puppet') do
      it { should be_file }
      it { should be_mode 644 }
      it { should contain 'This file is managed by puppet' }
      it { should contain '/var/log/puppetlabs/puppet/agent.log' }
    end

    describe file('/etc/puppetlabs/puppet/puppet.conf') do
      it { should be_file }
      it { should be_mode 744 }
      it { should contain 'lastrunfile = /opt/puppetlabs/puppet/last_run_summary.yaml' }
      it { should contain 'This file is managed by puppet' }
    end

    describe file('/etc/logrotate.d/puppet') do
      it { should be_file }
    end
  end

end
