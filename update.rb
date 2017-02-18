#!/usr/bin/env ruby

require 'colorize'
require 'fileutils'
require 'pathname'

include FileUtils

def cp(src, dst, mode = 0660)
  FileUtils.cp src, dst
  chmod mode, dst unless dst.directory?
end

def patch(src, dst, patch_id = '')
  touch dst unless dst.exist?
  patch_id = "-- #{src} CUSTOMIZATIONS --" if patch_id.empty?

  patch = File.read src
  target_contents = File.read dst

  if target_contents.include? patch_id
    # Replace existing patch
    existing_patch_pattern = Regexp.new("(?m)(?<=START #{patch_id}\n).*?(?=^. END #{patch_id})")
    patched_contents = target_contents.gsub existing_patch_pattern, patch 
    File.open(dst, 'w') { |f| f.puts patched_contents }
  else
    # Previously unpatched. Just append the patch.
    File.open(dst, 'a') do |f|
      f.puts "\n\n# START #{patch_id}"
      f.puts patch
      f.puts "# END #{patch_id}\n\n"
    end
  end
end

def status(s)
  puts s.blue
end

# ---------

home = Pathname(Dir.home)

status'-- Update any projects stored in Git submodues'
%x( git submodule update --remote )


status '-- .bashrc'
patch 'bashrc', home + '.bashrc'
cp 'git-prompt.sh', home


status '-- .gitconfig'
cp 'gitconfig', home + '.gitconfig'


status '-- .vimrc'
cp 'vimrc', home + '.vimrc'

status '    - vim files'
vimdir = home + '.vim'
mkdir vimdir unless Dir.exists? vimdir
cp_r 'vim/.', vimdir
# Remove the .git file...
rm vimdir + 'bundle/vim-commentary/.git'


status '-- .rvmrc'
cp 'rvmrc', home + '.rvmrc'

