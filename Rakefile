require 'rake'
require 'rake/clean'                       
require 'rake/gempackagetask'
require "rake/rdoctask"
require 'spec/rake/spectask'
require 'fileutils'
include FileUtils
require File.join(File.dirname(__FILE__),"lib","siffer")
include Siffer

spec = Gem::Specification.new do |s|
  s.name = "siffer"
  s.version = Siffer.version
  s.platform = Gem::Platform::RUBY
  s.author = "Clint Hill"
  s.email = "clint.hill@h3osoftware.com"
  s.homepage = "http://h3osoftware.com/siffer"
  s.summary = "Siffer - School Interoperability Framework by h3o(software)"
  s.rubyforge_project = "siffer"
  s.require_path = "lib"
  s.files        = %w( LICENSE README.rdoc Rakefile ) + Dir["{spec,lib,doc}/**/*"]
  s.bindir = "bin"
  s.executables = %w( siffer )
  s.add_dependency "uuid"
end

Rake::GemPackageTask.new(spec) do |package|
 package.gem_spec = spec
end

##############################################################################
# rSpec
##############################################################################
desc 'Run all specs and rcov'
task :spec => ["spec:default"]
namespace :spec do
  Spec::Rake::SpecTask.new('default') do |t|
      t.spec_opts = ["--format", "specdoc", "--colour"]
      t.spec_files = Dir['spec/**/*_spec.rb'].sort
      t.libs = ['lib']
      t.rcov = true
      t.rcov_opts = ["--exclude 'bin,doc,pkg,spec,#{Gem::path.join(',')}'"] 
  end
end

##############################################################################
# Documentation
##############################################################################
task :doc => ["doc:rdoc"]
namespace :doc do
  Rake::RDocTask.new do |rdoc|
    files = ["README.rdoc","LICENSE","lib/**/*.rb"]
    rdoc.rdoc_files.add(files)
    rdoc.main = "README.rdoc"
    rdoc.title = "Siffer == h3o(software) SIF"
    rdoc.rdoc_dir = "doc/rdoc"
    rdoc.options << "--line-numbers" << "--inline-source"
  end
end