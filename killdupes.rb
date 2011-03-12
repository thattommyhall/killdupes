#!/usr/bin/env ruby

require 'find'
require 'digest/md5'

$BUFLEN = 1024

def init_hash(file)
  hash = Digest::MD5.new
  open(file, "r") do |io|
    while (!io.eof)
      readBuf = io.readpartial($BUFLEN)
      hash.update(readBuf)
    end
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

class Hash
  def delete_ones
    delete_if {|key,val| val.size == 1}
  end
end

files_by_size = {}
files_by_size.default = []

Find.find('/home/tom/Dropbox/') do |path|
  if File.file? path
    files_by_size[File.size(path)] += [path]
  end
end

files_by_init_hash = {}
files_by_init_hash.default = []

files_by_size.delete_ones.values.flatten.each do |path|
  files_by_init_hash[init_hash(path)] += [path]
end

files_by_full_hash = {}
files_by_full_hash.default = []

files_by_init_hash.delete_ones.values.flatten.each do |path|
  files_by_full_hash[full_hash(path)] += [path]
end

files_by_full_hash.values.each do |list_of_matches|
  puts '******************************'
  list_of_matches.each {|match| puts match}
end


