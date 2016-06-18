require 'bundler/gem_tasks'
require 'rake/testtask'

require 'dotenv'
Dotenv.load

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

puts "CODECLIMATE_REPO_TOKEN = #{ENV['CODECLIMATE_REPO_TOKEN']}"

task :default => :test
