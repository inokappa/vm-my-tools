#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require 'yaml'                                                           
require 'terminal-table'

config = YAML.load(File.read("config.yml"))
#
rows = []
Net::SSH.start(config['host'], config['user'], :password => config['password']) do |ssh|
  vmuuids_raw = ssh.exec! "xe vm-list power-state=running is-control-domain=false params=uuid | awk -F\": \" '{print $2}'"
  vmuuids = [vmuuids_raw.sub(/[\r\n]*\z/, %())]
  vmuuids.each do |vmuuid|
    vm_name = ssh.exec! "xe vm-list uuid=#{vmuuid} params=name-label | awk -F\": \" '{print $2}'"
    cpu = ssh.exec! "xe vm-param-get uuid=#{vmuuid} param-name=VCPUs-utilisation"
    mem = ssh.exec! "xe vm-data-source-query data-source=memory uuid=#{vmuuid}"
    mem_free = ssh.exec! "xe vm-data-source-query data-source=memory_internal_free uuid=#{vmuuid}"
    rows << ["#{vm_name}","#{cpu}","#{mem}","#{mem_free}"] 
  end
end
#
table = Terminal::Table.new :headings => ['vm_name','cpu','mem','mem_free'], :rows => rows
#
puts table
