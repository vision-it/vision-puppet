require 'spec_helper'
require 'hiera'

describe 'vision_puppet::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'raise error' do
        let(:params) do
          {
            location: 'int'
          }
        end

        it { is_expected.to compile.and_raise_error(/PuppetDB not defined/) }
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

      context 'compile with vrt' do
        let(:params) do
          {
            location: 'vrt'
          }
        end

        it { is_expected.to contain_class('vision_puppet::puppetdb') }
        it { is_expected.to contain_class('vision_puppet::puppetsql') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
