#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require 'yaml'                                                           
require 'terminal-table'

config = YAML.load(File.read("config.yml"))
#
class Con
  def initialize(options)
    @options = options
  end
  def connect
    @ssh = Net::SSH.start(@options) 
  end
  def connection
    @ssh if @ssh
  end
  def cmd(command)
    connection.exec!
  end
end

class Uuid < Con
  def get_uuid
    vmuuids_raw = cmd("xe vm-list power-state=running is-control-domain=false params=uuid | awk -F\": \" '{print $2}'")
    vmuuids = vmuuids_raw.split("\n\n\n")
  end
end

class Command < Con
  def initialize(vmuuid)
    @vmuuid = "#{vmuuid}"
  end
  def vm_name_cmd
    cmd("xe vm-param-get uuid=", @vmuuid ," param-name=name-label")
  end
  def cpu_cmd
    cmd("xe vm-param-get uuid=", @vmuuid ," param-name=name-label")
  end
  def mem_cmd
    cmd("xe vm-data-source-query data-source=memory uuid=", @vmuuid)
  end
  def mem_free_cmd
    cmd("xe vm-data-source-query data-source=memory_internal_free uuid=", @vmuuid)
  end
end
#
print "connecting to server...#{ARGV[0]}...\n"
print "connecting to server...#{config['user']}...\n"
#rows = []
#Net::SSH.start(ARGV[0], config['user'], :password => config['password'], :port => config['port']) do |ssh|
#  vmuuids_raw = ssh.exec! "xe vm-list power-state=running is-control-domain=false params=uuid | awk -F\": \" '{print $2}'"
#  vmuuids = vmuuids_raw.split("\n\n\n")
#  vmuuids.each do |vmuuid|
#    puts "#{vmuuid}"
#    chk = Com.new("#{vmuuid}")
#    rows << ["#{vm_name}","#{cpu}","#{mem}","#{mem_free}"] 
#  end
#end
#
#chk = Con.new (ARGV[0], config['user'], :password => config['password'], :port => config['port'])
p chk
p chk::Command
#table = Terminal::Table.new :headings => ['vm_name','cpu','mem(byte)','mem_free(KB)'], :rows => rows
#
#puts table
