require "bundler/gem_tasks"
require 'rdoc/task'

task :default => [:test]

desc %Q|Run test(s) in project 'test' folder|
task :test do
  tests = Dir.glob("test/*_{spec,test}.rb").join(' ')
  ruby tests
end

desc %Q|Generates documentation|
RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/*.rb", 'bin/*.rb')
end

