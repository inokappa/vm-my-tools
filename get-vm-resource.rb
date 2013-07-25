#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require 'yaml'                                                           
require 'terminal-table'

config = YAML.load(File.read("config.yml"))
#
print "connecting server...#{ARGV[0]}...\n"
rows = []
Net::SSH.start(ARGV[0], config['user'], :password => config['password'], :port => config['port']) do |ssh|
  vmuuids_raw = ssh.exec! "xe vm-list power-state=running is-control-domain=false params=uuid | awk -F\": \" '{print $2}'"
  vmuuids = vmuuids_raw.split("\n\n\n")
  vmuuids.each do |vmuuid|
    vm_name = ssh.exec! "xe vm-param-get uuid=#{vmuuid} param-name=name-label"
    cpu = ssh.exec! "xe vm-param-get uuid=#{vmuuid} param-name=VCPUs-utilisation"
    mem = ssh.exec! "xe vm-data-source-query data-source=memory uuid=#{vmuuid}"
    mem_free = ssh.exec! "xe vm-data-source-query data-source=memory_internal_free uuid=#{vmuuid}"
    rows << ["#{vm_name}","#{cpu}","#{mem}","#{mem_free}"] 
  end
end
#
table = Terminal::Table.new :headings => ['vm_name','cpu','mem(byte)','mem_free(KB)'], :rows => rows
#
puts table
