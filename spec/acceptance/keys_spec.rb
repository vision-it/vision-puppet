require 'spec_helper_acceptance'

describe 'vision_puppet::keys' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-FILE
        class { 'vision_puppet::keys': }
      FILE
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'files provisioned' do
    describe file('/root/.ssh/config') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'managed by Puppet' }
      its(:content) { is_expected.to match 'Host git.example.com' }
      its(:content) { is_expected.to match 'User foo' }
      its(:content) { is_expected.to match 'Port 2222' }
      its(:content) { is_expected.to match 'IdentityFile /root/.ssh/puppetdeploy' }
      its(:content) { is_expected.to match 'BatchMode yes' }
      its(:content) { is_expected.to match 'Host gitlab.com' }
    end

    describe file('/root/.ssh/puppetdeploy') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 600 }
      its(:content) { is_expected.to match 'my-secret-key' }
    end

    describe file('/root/.ssh/puppetdeploy.pub') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 600 }
      its(:content) { is_expected.to match 'my-public-key' }
    end
  end
end
