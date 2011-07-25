# -*- ruby -*-

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)

require 'rake'
require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'
require 'ci/reporter/rake/cucumber'
require 'cucumber'
require 'cucumber/rake/task'
require 'warbler'
require 'yard'

### Hack for cucumber on jruby
class Cucumber::Rake::Task::ForkedCucumberRunner
  def runner
    # Disable bundler exec - It slows things down and doesn't always work.
    [RUBY]
  end
end
class Cucumber::Rake::Task::RCovCucumberRunner
  def runner
    # Turn on debug so rcov is more accurate.
    [RUBY, '--debug']
  end
end

# Verify that we're in jruby. This helped with debugging.
raise "I require JRuby" unless RUBY_ENGINE == "jruby"

TOP = File.dirname(__FILE__)
TARGET_DIR  = File.join(TOP, "target")
BUILD_DIR   = File.join(TOP, "build")
COVERAGE_DIR = File.join(TARGET_DIR, "coverage")
DOC_DIR = File.join(TARGET_DIR, "doc")
AGGREGATE_COVERAGE = File.join(TARGET_DIR, "coverage.data")
RCOV_OPTS = ['--exclude', 'spec,features,/gems/,jsignal_internal',
             '--output', COVERAGE_DIR]
SPEC_REPORT_DIR = File.join TARGET_DIR, "spec-reports"
FEATURES_REPORT_DIR = File.join TARGET_DIR, "features-reports"
ENV['CI_REPORTS'] = SPEC_REPORT_DIR

# Default task is the coverage report and jar.
task :default => [:jar]
task :all => [:rcov, :yard, :jar]

desc "Run all tests"
task :tests => [:features, :spec]

### Build the staging directory
task :build do
  rm_rf BUILD_DIR
  mkdir BUILD_DIR
  cp_r Dir["src/*"], "build/"
  cp Dir["Gemfile*"].to_a, "build/"
end

### Build Jar ###
desc "Build the jar"
task :jar => [:build] do
  Dir.chdir BUILD_DIR do |path|
    Rake::Task[:warble].invoke
  end
end

Warbler::Task.new :warble do |t|
  t.config.jar_name = File.join(TARGET_DIR, "iated")
end
# There is a weird bug in warbler where the jar grows without
# bound unless this extra clean is specified.
task :warble => [:target_dir, :'warble:clean']

# TODO: Create .exe (windows with launch4j)
# TODO: Create .app (os-x)

# RCov
desc "Run all examples and features with RCov"
task :rcov => [:'rcov:clean', :'features:rcov_aggregate', :'spec:rcov_aggregate']
# TODO: The rcov aggregate stuff isn't working, you can tell by the cucumber and rake coverage methods on mcp.

desc "Remove the rcov data"
task :'rcov:clean' do
  rm_rf COVERAGE_DIR
  rm_f AGGREGATE_COVERAGE
end


# Jenkins
desc "Continuous integration"
task :ci => [:sloccount, :download_jars, :'features:ci', :'spec:ci', :yard, :jar]

# SLOCCount
desc "Generate SLOCCount"
task :sloccount => :target_dir do
  system "sloccount --duplicates --wide --details src spec > target/sloccount.sc"
end


YARD::Rake::YardocTask.new do |t|
  t.files = ['src/**/*.rb', '**/*.md']
  t.options = ['--output-dir', DOC_DIR]
end

desc "Generate UML graph (requires dot, download Graphviz from http://www.graphviz.org/)"
task :graph => :yard do
  # FIXME use --db to specify specific yardoc db, but this doesn't seem to work with current version of yard-graph
  `yard graph --full | dot -T pdf -o #{TARGET_DIR}/yard-graph.pdf`
  puts "Generated diagram to #{TARGET_DIR}/yard-graph.pdf"
end


### RSpec ###
desc "Run RSpec code examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.skip_bundler = true # Suggested on some website about jruby.
end

namespace :spec do
  desc "Run RSpec code examples with RCov"
  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.skip_bundler = true # Suggested on some website about jruby.
    t.ruby_opts = "--debug"
    t.rcov = true
    t.rcov_opts = RCOV_OPTS
  end
  task :rcov => [:jruby_debug, :target_dir]

  desc "Run RSpec code examples with RCov (aggregate)"
  RSpec::Core::RakeTask.new(:rcov_aggregate) do |t|
    t.skip_bundler = true # Suggested on some website about jruby.
    t.ruby_opts = "--debug"
    t.rcov = true
    t.rcov_opts = RCOV_OPTS + ['--aggregate', AGGREGATE_COVERAGE]
  end
  task :rcov_aggregate => [:jruby_debug, :target_dir]

  desc "Run RSpec code examples for CI (with rcov)"
  task :ci => [:'ci:setup:rspec', :rcov_aggregate]
end


### Cucumber ###
desc "Run Cucumber features"
Cucumber::Rake::Task.new(:features) do |t|
    t.libs = ["src/lib"]
#  t.skip_bundler = true # Suggested on some website about jruby.
end

namespace :features do
  Cucumber::Rake::Task.new(:rcov, "Run Cucumber features with RCov") do |t|
    t.libs = ["src/lib"]
    t.rcov = true
    t.rcov_opts = RCOV_OPTS
  end
  task :rcov => [:jruby_debug, :target_dir]

  Cucumber::Rake::Task.new(:rcov_aggregate, "Run Cucumber features with RCov (aggregate)") do |t|
    t.libs = ["src/lib"]
    t.rcov = true
    t.rcov_opts = RCOV_OPTS + ['--aggregate', AGGREGATE_COVERAGE]
  end
  task :rcov_aggregate => [:jruby_debug, :target_dir]

  # I couldn't get ci_reporter to work right with cucumber, so I'm
  # just using the default formatter bult-in to cucumber.
  Cucumber::Rake::Task.new(:ci, "Run Cucumber features for CI (with rcov)") do |t|
    t.libs = ["src/lib"]
    t.cucumber_opts = ['--format', 'junit',
                       '--out', FEATURES_REPORT_DIR]
    t.rcov = true
    t.rcov_opts = RCOV_OPTS + ['--aggregate', AGGREGATE_COVERAGE]
  end
  task :ci => [:jruby_debug, :target_dir]
end


### Utility ####
# Create the target directory.
task :target_dir do
  mkdir TARGET_DIR unless File.directory? TARGET_DIR
end

# Turn on --debug for jruby, used for rcov targets
task :jruby_debug do
  ENV['JRUBY_OPTS'] = "#{ENV['JRUBY_OPTS']} --debug"
end

desc "Cleans up the work environment"
task :clean => :'warble:clean' do
  rm_rf TARGET_DIR
  rm_rf BUILD_DIR
  rm_rf '.yardoc'
end

### Maven ###
# Fetching Java jars.

## Generates the temporary pom file
def build_pom_xml
  require 'yaml'
  require 'nokogiri'
  jars_config = YAML::load_file "jars.yml"

  builder = Nokogiri::XML::Builder.new do |pom|
    pom.project do
      pom.modelVersion  '4.0.0'
      pom.groupId       'none'
      pom.artifactId    'none'
      pom.version       '1.0'
      pom.dependencies do

        jars_config[:jars].each do |jar_config|
          pom.dependency do
            pom.groupId     jar_config[:groupId]
            pom.artifactId  jar_config[:artifactId]
            pom.version     jar_config[:version]
          end
        end
      end
    end
  end
  return builder.to_xml
end

## Returns a list of jars' paths to copy.
#
# This also causes Maven to download the jars and
# put it in its local repository.
def get_jar_paths

  begin
    File.open(".mvnfetch.xml", 'w') do |f|
      f.write build_pom_xml
    end

    # This is a simple state machine.  It looks for a line that
    # says it has resolved the depencies and then parses each line after that
    # until an empty line.
    # [start] -> [resolutions] -> [end]
    state = :start

    # Simple regex for the 6 elements separated by colons.
    re = Regexp.new( (["([^:]+)"] * 6).join(":"))

    # Collect the paths here.
    paths = []

    # Warn the user this may take a while.
    puts "Running Maven to get the correct jars (this may take a while)..."

    # Execute Maven, and parse the input.
    `mvn -f .mvnfetch.xml dependency:resolve -DoutputAbsoluteArtifactFilename=true`.each do |line|
      line.chomp!

      # Split out the log level (INFO, WARNING, ERROR) from the actual message.
      # Usual format of Maven output is: [INFO]   Something happened some place.
      if line =~ /^\[([A-Z]+)\]\s+(.*)$/
        lvl = $1
        txt = $2
        if "INFO" == lvl
          if :start == state
            if txt =~ /The following files have been resolved/
              state = :resolutions
            end
          elsif :resolutions == state
            if txt =~ /^\s*$/
              state = :end
            else
              m = re.match(line)
              if m
                paths << m[6] # The 6th element is the path to the jar.
              else
                raise "Unable to parse maven: #{txt.inspect}"
              end
            end
          end
        else
          # Ignore the stupid warnings
          puts "maven: #{line}" unless line =~ /decrypting password/
        end
      else
        # Ignore the stupid warnings
        puts "maven: #{line}" unless line =~ /password is not set/
      end
    end # mvn
  ensure
    rm_f ".mvnfetch.xml"
  end

  return paths
end

desc "Downloads the required jars and their dependencies"
task :download_jars do
  paths = get_jar_paths

  # Remove previously downloaded jars.
  Dir[File.join("src", "lib", "*.jar")].each do |path|
    File.unlink path
  end

  # Copy over new jars.
  paths.each do |path|
    cp(path, File.join("src", "lib"))
  end
end
