require 'spec_helper_acceptance'

describe 'vision_puppet::hiera' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-EOS
        class { 'vision_puppet::hiera': }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/code/hiera.yaml') do
      it { is_expected.to be_symlink }
    end

    describe file('/etc/puppetlabs/puppet/hiera.yaml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'pkcs7_private_key' }
      it { is_expected.to contain 'datadir' }
      it { is_expected.to contain 'location' }
      it { is_expected.to contain 'role' }
      it { is_expected.to contain 'type' }
      it { is_expected.to contain 'common' }
    end
  end
end
