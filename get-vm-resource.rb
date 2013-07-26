#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require 'yaml'                                                           
require 'terminal-table'

config = YAML.load(File.read("config.yml"))

# connect to xenserver
class Con
  def initialize(host,user,password)
    @host = host
    @user = user
    @password = password
  end
  def ssh_exec(command)
    ssh = Net::SSH.start(@host, @user, @password) 
    ssh.exec! command
  end
end

# commands
class Commands < Con
  def get_vm_uuid
    vm_uuid_raw = ssh_exec("xe vm-list power-state=running is-control-domain=false params=uuid | awk -F\": \" '{print $2}'")
    vm_uuid = vm_uuid_raw.split("\n\n\n")
  end
  def get_vm_name(vmuuid)
    ssh_exec("xe vm-param-get uuid=#{vmuuid} param-name=name-label")
  end
  def get_vm_cpu(vmuuid)
    ssh_exec("xe vm-param-get uuid=#{vmuuid} param-name=VCPUs-utilisation")
  end
  def get_vm_mem(vmuuid)
    ssh_exec("xe vm-data-source-query data-source=memory uuid=#{vmuuid}")
  end
  def get_vm_mem_free(vmuuid)
    ssh_exec("xe vm-data-source-query data-source=memory_internal_free uuid=#{vmuuid}")
  end
end

# get params
rows = []
puts "Connect to XenServer #{config['host']}..."
chk = Commands.new(config['host'], config['user'], :password => config['password'])
chk.get_vm_uuid.each do |vmuuid|
  rows << ["#{chk.get_vm_name(vmuuid)}","#{chk.get_vm_cpu(vmuuid)}","#{chk.get_vm_mem(vmuuid)}","#{chk.get_vm_mem_free(vmuuid)}"]
end

# genarate table
table = Terminal::Table.new :headings => ['vm_name','cpu','mem(byte)','mem_free(KB)'], :rows => rows
puts table
