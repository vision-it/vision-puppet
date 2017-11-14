require 'spec_helper_acceptance'

describe 'vision_puppet::puppetsql' do
  context 'with defaults' do
    it 'idempotentlies run' do
      pp = <<-EOS
        class { 'vision_puppet::puppetsql':
         listen_address => '0.0.0.0',
         sql_user       => 'foobar',
         sql_password   => 'foobar',
        }
      EOS

      apply_manifest(pp, catch_failures: false)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'postgres installed and running' do
    describe package('postgresql-common') do
      it { is_expected.to be_installed }
    end

    describe service('postgresql') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
