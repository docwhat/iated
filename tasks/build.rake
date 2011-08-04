# -*- ruby -*-

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
