#!/usr/bin/env rake

require 'rake/packagetask'

desc 'Target for CI server'
task :ci => [:dump, :test]

desc 'Dump Vim\'s version info'
task :dump do
  sh 'vim --version'
end

desc 'Run tests with vspec'
task :test do
  sh 'bundle exec vim-flavor test'
end

Rake::PackageTask.new('vim-skeleton') do |p|
  tag = `git describe --tags`.chomp
  p.version = tag.sub(/^v/, '')
  p.need_zip = true
  p.package_files.include(['plugin/*.vim', 'autoload/*.vim', 'doc/*.txt'])
end
