#!/usr/bin/env ruby

require 'find'
require 'digest/md5'

$BUFLEN = 1024

def init_hash(file)
  hash = Digest::MD5.new
  open(file, "r") do |io|
    hash.update(io.readpartial($BUFLEN))
  end
  return hash.hexdigest
end

def full_hash(file)
  hash = Digest::MD5.new
  open(file, "r") do |io|
    while (!io.eof)
      readBuf = io.readpartial($BUFLEN)
      hash.update(readBuf)
    end
  end
  return hash.hexdigest
end

ARGV.each do |file|
  puts "filename: #{file}"
  puts "full_hash: #{full_hash(file)}"
  puts "init_hash: #{init_hash(file)}"
end

class Hash
  def delete_ones
    delete_if {|key,val| val.size == 1}
  end
end

files_by_size = {}
files_by_size.default = []

Find.find('./test') do |path|
  if File.file? path
    files_by_size[File.size(path)] += [path]
  end
end

puts files_by_size.delete_ones
