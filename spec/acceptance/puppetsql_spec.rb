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

  context 'package installed' do
    describe package('postgresql-common') do
      it { is_expected.to be_installed }
    end
  end
end
