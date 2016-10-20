require 'beaker-rspec'
require 'yaml'

install_puppet_agent_on hosts, {}

# This tries to install puppet 3.7 (for whatever reason)
# --goschlui[15.06.2016]
# hosts.each do |host|
#   on host, install_puppet
# end

RSpec.configure do |c|
  # Project root
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('/').last.sub('-','_')

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)

    modules_fixtures = YAML.load_file(module_root + '/.fixtures.yml')
    modules = modules_fixtures['fixtures']['repositories']

    hosts.each do |host|
      modules.each do |moduleName, moduleInfo|
        puts 'Fetch ' + moduleName + ' ' + moduleInfo['ref'] + ' from ' + moduleInfo['repo']
        on host, 'git clone ' + moduleInfo['repo'] + ' /etc/puppetlabs/code/environments/production/modules/' + moduleName
        on host, 'cd /etc/puppetlabs/code/environments/production/modules/' + moduleName + ' && git checkout ' + moduleInfo['ref']
      end
    end

  end

end


