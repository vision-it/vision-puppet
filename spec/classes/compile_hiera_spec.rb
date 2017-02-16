require 'spec_helper'
require 'hiera'

describe 'vision_puppet::hiera' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :is_pe => false,
          :pe_server_version => false
        })
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

    end
  end
end
