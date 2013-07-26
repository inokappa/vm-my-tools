#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require 'yaml'                                                           
require 'terminal-table'

config = YAML.load(File.read("config.yml"))
#
class Con
  def initialize(host,user,password)
    @host = host
    @user = user
    @password = password
  end
  def connect
    @ssh = Net::SSH.start(@host, @user, @password) 
  end
  def cmd(command)
    @ssh.exec! @command
  end
end

#class Uuid < Con
#  def get_uuid
#    vmuuids_raw = cmd("xe vm-list power-state=running is-control-domain=false params=uuid | awk -F\": \" '{print $2}'")
#    vmuuids = vmuuids_raw.split("\n\n\n")
#  end
#end

class Command < Con
#  def initialize(vmuuid)
#    @vmuuid = "#{vmuuid}"
#  end
  def pwd_cmd
    cmd("pwd")
  end
end
#
print "connecting to server...#{config['host']}...\n"
print "connecting to server...#{config['user']}...\n"
print "connecting to server...#{config['port']}...\n"
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
#chk = Command.new(config['host'], config['user'], :password => config['password'], :port => config['port'])
chk = Command.new(config['host'], config['user'], :password => config['password'])
p chk
p chk.pwd_cmd
#table = Terminal::Table.new :headings => ['vm_name','cpu','mem(byte)','mem_free(KB)'], :rows => rows
#
#puts table
