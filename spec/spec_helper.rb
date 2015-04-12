require 'serverspec'
require 'net/ssh'
require 'json'

set :backend, :ssh

if ENV['json_file'] == 'dev.json'
    set_property JSON.parse(File.read("spec/dev.json"))
end

if ENV['json_file'] == 'production.json'
    set_property JSON.parse(File.read("spec/production.json"))
end

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

#options[:user] ||= Etc.getlogin
options[:user] ||= "deve"

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'