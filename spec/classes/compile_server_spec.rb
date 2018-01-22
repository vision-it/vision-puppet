require 'spec_helper'
require 'hiera'

describe 'vision_puppet::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        let(:params) do
          {
            location: 'int',
            pdb_server: 'localhost'
          }
        end

        it { is_expected.to contain_class('puppetdb::master::config') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
