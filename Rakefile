#!/usr/bin/env rake

require 'rake/packagetask'
require 'json'

plugin = JSON.load(File.new('addon-info.json'))

desc 'Target for CI server'
task ci: [:dump, :test]

desc 'Dump Vim\'s version info'
task :dump do
  sh 'vim --version'
end

desc 'Run tests with vspec'
task :test do
  sh 'bundle exec vim-flavor test'
end

desc 'Rebuild the documentation with vimdoc'
task :doc do
  sh 'vimdoc ./'
end

desc 'Prompt to upload archive to vim.org'
task :publish do
  cmd = 'open http://www.vim.org/scripts/add_script_version.php?script_id=%i'
  sh format(cmd, plugin['script_id'])
end

Rake::PackageTask.new(plugin['name']) do |p|
  p.version = plugin['version']
  p.need_zip = true
  p.package_files.include(['plugin/*.vim', 'autoload/*.vim', 'doc/*.txt'])
end
