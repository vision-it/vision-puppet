require 'spec_helper'
require 'hiera'

describe 'vision_puppet::puppetdb' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile }
      end
    end
  end
end
