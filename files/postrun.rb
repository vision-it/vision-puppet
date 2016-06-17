#!/usr/bin/ruby

require 'yaml'

location = `/opt/puppetlabs/bin/facter location`.chomp

Dir.entries('/etc/puppetlabs/code/environments').each do |environment|
  next if environment == '.' || environment == '..'
  next if ! File.exists? "/etc/puppetlabs/code/environments/#{environment}/modules.yaml"

  conf = YAML.load_file("/etc/puppetlabs/code/environments/#{environment}/modules.yaml")
  locations = conf['modules']
  modules = locations[location.to_s]

  if modules.nil?
    puts "No module configuration for #{environment}, use default"
    modules = locations['default']
  end

  system("rm -Rf /etc/puppetlabs/code/environments/#{environment}/dist/")
  system("mkdir -p /etc/puppetlabs/code/environments/#{environment}/dist/")

  if File.directory? '/vagrant'
    modules.each do |moduleName, options|
      if File.directory? "/opt/puppet/modules/#{moduleName}"
        puts "Deploying module #{moduleName} from /opt/puppet/modules/#{moduleName}"
        system("ln -sf /opt/puppet/modules/#{moduleName} /etc/puppetlabs/code/environments/#{environment}/dist/")
      else
        puts "Deploying module #{moduleName} from #{options['url']}"
        system("/usr/bin/git clone #{options['url']} --branch #{options['ref']} --single-branch /etc/puppetlabs/code/environments/#{environment}/dist/#{moduleName}")
      end
    end

    puts "Deploy hiera /etc/puppetlabs/code/hieradata/#{environment} from /opt/puppet/hiera"
    system("rm -Rf /etc/puppetlabs/code/hieradata/#{environment}")
    system("ln -sf /opt/puppet/hiera /etc/puppetlabs/code/hieradata/#{environment}")
  else
    modules.each do |moduleName, options|
      puts "Deploying module #{moduleName} from #{options['url']}"
      system("/usr/bin/git clone #{options['url']} --branch #{options['ref']} --single-branch /etc/puppetlabs/code/environments/#{environment}/dist/#{moduleName}")
    end
  end
end
