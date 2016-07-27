require 'spec_helper_acceptance'

describe 'vision_puppet::r10k' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'vision_puppet::r10k':
         user     => 'foobar',
         password => 'foobar',
        }
      EOS

      apply_manifest(pp, :catch_failures => false)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'files provisioned' do
    describe file('/etc/puppetlabs/r10k/postrun.rb') do
      it { should be_file }
      it { should be_mode 755 }
    end
  end

end
