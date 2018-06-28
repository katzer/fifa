# Apache 2.0 License
#
# Copyright (c) 2016 Sebastian Katzer, appPlant GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'fileutils'

mruby_version = ENV['MRUBY_VERSION']
mruby_version = '1.4.1' if !mruby_version || mruby_version.empty?

file :mruby do
  if mruby_version == 'head'
    sh "git clone --depth=1 https://github.com/mruby/mruby"
  else
    sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/#{mruby_version}.tar.gz -s -o - | tar zxf -"
    FileUtils.mv("mruby-#{mruby_version}", "mruby")
  end
end

APP_NAME=ENV["APP_NAME"] || "fifa"
APP_ROOT=ENV["APP_ROOT"] || Dir.pwd
# avoid redefining constants in mruby Rakefile
mruby_root=File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
mruby_config=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.glibc-2.14.rb")
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

load File.join(File.expand_path(File.dirname(__FILE__)), "mrbgem.rake")

current_gem = MRuby::Gem.current
current_gem.build ||= MRuby::Build.current
current_gem.setup
app_version = current_gem.version
APP_VERSION = (app_version.nil? || app_version.empty?) ? "unknown" : app_version

desc "compile binary"
task :compile => [:all] do
  Dir["#{mruby_root}/build/*-[linux|mingw]*/bin/*"].each do |bin|
    sh "strip --strip-unneeded #{bin}" rescue nil
  end

  Dir["#{mruby_root}/build/*-apple-*/bin/*"].each do |bin|
    sh "x86_64-apple-darwin15-strip -u -r -arch all #{bin}" rescue nil
  end
end

namespace :test do
  desc "run mruby & unit tests"
  # only build mtest for host
  task :mtest => :compile do
    # in order to get mruby/test/t/synatx.rb __FILE__ to pass,
    # we need to make sure the tests are built relative from mruby_root
    MRuby.each_target do |target|
      # only run unit tests here
      target.enable_bintest = false
      run_test if target.test_enabled?
    end
  end

  def clean_env(envs)
    old_env = {}
    envs.each do |key|
      old_env[key] = ENV[key]
      ENV[key] = nil
    end
    yield
    envs.each do |key|
      ENV[key] = old_env[key]
    end
  end

  desc "run integration tests"
  task :bintest => :compile do
    MRuby.each_target do |target|
      clean_env(%w(MRUBY_ROOT MRUBY_CONFIG)) do
        run_bintest if target.bintest_enabled?
      end
    end
  end
end

desc "run all tests"
Rake::Task['test'].clear
task :test => ["test:mtest", "test:bintest"]

desc "cleanup"
task :clean do
  sh "rake clean"
end

desc "cleanup"
task :cleanall do
  sh "rake deep_clean"
end

desc "generate a release tarball"
task :release => :compile do
  require 'tmpdir'

  Dir.chdir(mruby_root) do
    # since we're in the mruby/
    release_dir  = "releases/v#{APP_VERSION}"
    release_path = Dir.pwd + "/../#{release_dir}"
    app_name     = "#{APP_NAME}-#{APP_VERSION}"
    FileUtils.mkdir_p(release_path)

    Dir.mktmpdir do |tmp_dir|
      Dir.chdir(tmp_dir) do
        MRuby.each_target do |target|
          next if name == "host"

          arch = name
          bin  = "#{build_dir}/bin/#{exefile(APP_NAME)}"
          FileUtils.mkdir_p(name)
          FileUtils.cp(bin, name)

          Dir.chdir(arch) do
            arch_release = "#{app_name}-#{arch}"
            puts "Writing #{release_dir}/#{arch_release}.tgz"
            `tar czf #{release_path}/#{arch_release}.tgz *`
          end
        end

        puts "Writing #{release_dir}/#{app_name}.tgz"
        `tar czf #{release_path}/#{app_name}.tgz *`
      end
    end
  end
end

namespace :local do
  desc "show version"
  task :version do
    puts APP_VERSION
  end
end

def in_a_docker_container?
  `grep -q docker /proc/self/cgroup`
  $?.success?
end

MRuby.targets.keep_if { |_, t| t.bintest_enabled? } if ARGV[0] == 'test:bintest'
MRuby.targets.keep_if { |_, t| t.test_enabled? }    if ARGV[0] == 'test:mtest'
MRuby.targets.keep_if { |n, _| n == 'host' }        if ENV['MRUBY_CLI_LOCAL']

if ENV['MRUBY_CLI_LOCAL'] || ARGV[0].start_with?('test')
  Rake::Task['all'].prerequisites.keep_if do |p|
    MRuby.targets.any? { |n, _| p =~ %r{mruby/bin|/#{n}/} }
  end
end

Rake.application.tasks.each do |task|
  next if ENV["MRUBY_CLI_LOCAL"]
  unless task.name.start_with?("local:")
    # Inspired by rake-hooks
    # https://github.com/guillermo/rake-hooks
    old_task = Rake.application.instance_variable_get('@tasks').delete(task.name)
    desc old_task.full_comment
    task old_task.name => old_task.prerequisites do
      abort("Not running in docker, you should type \"docker-compose run <task>\".") \
        unless in_a_docker_container?
      old_task.invoke
    end
  end
end
