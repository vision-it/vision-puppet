require 'spec_helper'
require 'hiera'

describe 'vision_puppet::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end


      context 'compile' do

        let(:params) {{
                      :location => 'int'
                    }}

        it { is_expected.to contain_class('puppetdb::master::config') }
        it { is_expected.to compile.with_all_deps }

      end

      context 'compile with vrt' do

        let(:params) {{
                        :location => 'vrt',
                    }}

        it { is_expected.to contain_class('vision_puppet::puppetdb') }
        it { is_expected.to compile.with_all_deps }

      end


    end
  end
end
