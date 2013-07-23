#!/usr/bin/env ruby

require 'rubygems'
require 'net/ssh'
require 'yaml'                                                           
require 'terminal-table'

config = YAML.load(File.read("config.yml"))

Net::SSH.start(config['host'], config['user'], config['password']) do |ssh|
  puts ssh.exec! 'ls'
end

