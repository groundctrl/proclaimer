require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
require "spree/testing_support/extension_rake"

RSpec::Core::RakeTask.new

task :default do
  if Dir["spec/dummy"].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir("../../")
  end
  Rake::Task[:spec].invoke
end

desc "Generates a dummy app for testing"
task :test_app do
  ENV["LIB_NAME"] = "proclaimer"
  Rake::Task["extension:test_app"].invoke
  Rake::Task["test_app:cleanup"].invoke
end

desc "Remove references to JavaScript and CSS files from dummy app"
task "test_app:cleanup" do
  Dir["#{__dir__}/spec/dummy/vendor/**/all.{css,js}"].each do |path|
    content = File.read(path).sub(%r<^.*require spree/\S+/proclaimer.*$>, "")
    File.open(path, "w") { |file| file.write(content) }
  end
end
