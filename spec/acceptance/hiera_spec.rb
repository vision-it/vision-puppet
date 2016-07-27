require 'spec_helper_acceptance'

describe 'vision_puppet::hiera' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'vision_puppet::hiera':
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/code/hiera.yaml') do
      it { should be_symlink }
    end

    describe file('/etc/puppetlabs/puppet/hiera.yaml') do
      it { should be_file }
      it { should contain 'location' }
      it { should contain 'tier' }
      it { should contain 'role' }
      it { should contain 'type' }
      it { should contain 'common' }
    end
  end

end
