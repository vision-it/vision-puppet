#!/usr/bin/ruby

require 'yaml'
require 'open3'

location = `/opt/puppetlabs/bin/facter location`.chomp
threads = Array.new
$errors = []

def cloneModule(moduleName, environment, moduleOptions)
  puts "Deploying module #{moduleName} from #{moduleOptions['url']}"
  stdout, stderr, status = Open3.capture3("/usr/bin/git clone #{moduleOptions['url']} --branch #{moduleOptions['ref']} --single-branch /etc/puppetlabs/code/environments/#{environment}/dist/#{moduleName}")
  if stderr.include? 'fatal'
    $errors.push(stderr)
  end
end

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
        threads.push Thread.new{cloneModule(moduleName, environment, options)}
      end
    end

    puts "Deploy hiera /etc/puppetlabs/code/hieradata/#{environment} from /opt/puppet/hiera"
    system("rm -Rf /etc/puppetlabs/code/hieradata/#{environment}")
    system("ln -sf /opt/puppet/hiera /etc/puppetlabs/code/hieradata/#{environment}")
  else
    modules.each do |moduleName, options|
      threads.push Thread.new{cloneModule(moduleName, environment, options)}
    end
  end
end

threads.each { |t| t.join }
$errors.each {|error| $stderr.puts error}
