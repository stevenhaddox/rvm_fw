require 'yaml'
require 'dotenv/tasks'

namespace :boot do
  desc "Download Rubies in config/rubies.yml, keep existing with: $ rake boot:strap KEEP=true"
  task :strap => :dotenv do
    # Set common directory paths as variables for quick referencing
    IGNORED_FILES = ENV['IGNORED_FILES'] || ['.','..','.DS_Store','.git','.svn']
    APP_ROOT      = ENV['APP_ROOT']      || File.expand_path('../../..', __FILE__)
    RUBIES_PATH   = ENV['RUBIES_PATH']   || File.expand_path('../../../public/rubies', __FILE__)

    # Delete the 'public/rubies' directory to ensure we only download Rubies &
    # packages specified in the rubies.yml file.
    unless ENV["KEEP"]
      FileUtils.rm_rf RUBIES_PATH
    else
      # Nuke rvm package dir due to weird naming convention and avoiding duplicates
      # TODO: Patch downloading dupes and avoid nuking this directory
      FileUtils.rm_rf "#{RUBIES_PATH}/packages/rvm"
      # TODO: Fix this, for now nuke libyaml / yaml dir to avoid symlink errors
      FileUtils.rm_rf "#{RUBIES_PATH}/packages/libyaml"
      FileUtils.rm_rf "#{RUBIES_PATH}/packages/yaml"
    end

    # See if we have a custom rubies.yml file, if not use the .example default.
    if File.exist? File.expand_path("#{APP_ROOT}/config/rubies.yml")
      rubies_yaml_file = File.expand_path("#{APP_ROOT}/config/rubies.yml")
    else
      rubies_yaml_file = File.expand_path("#{APP_ROOT}/config/rubies.yml.example")
      puts "\r\nYou haven't customized config/rubies.yml, installing default RVM::FW Rubies...\r\n\r\n"
      sleep 5
    end

    # All your rubies are belong to us.
    rubies = YAML::load_file(rubies_yaml_file)
    rubies.each do |ruby, params|
      unless File.exist? "#{RUBIES_PATH}/#{params[:path_prefix]}/#{ruby}"
        puts "-"*80
        puts "Starting #{ruby}"
        puts "-"*80

        # Create path from params[:path_prefix]
        puts "Creating directory #{RUBIES_PATH}/#{params[:path_prefix]}\r\n"
        FileUtils.mkdir_p "#{RUBIES_PATH}/#{params[:path_prefix]}"

        # Download each ruby from params[:url]
        puts "Downloading #{ruby}..."
        `wget --no-check-certificate #{params[:url]} -P #{RUBIES_PATH}/#{params[:path_prefix]}`
        puts "Completed download\r\n\r\n\r\n"
      else
        puts "-"*80
        puts "Skipping #{ruby}..."
        puts "File already exists: #{RUBIES_PATH}/#{params[:path_prefix]}/#{ruby}"
        puts "-"*80
        puts "\r\n\r\n"
      end
    end

    # Rename rvm packages to fit old script naming style:
    Dir.glob(File.expand_path("#{RUBIES_PATH}/packages/rvm/*")).each do |rvm_file|
      unless File.basename(rvm_file).include? '.tar.gz'
        puts "Renaming #{File.basename(rvm_file)} to rvm-#{File.basename(rvm_file)}.tar.gz\r\n\r\n"
        File.rename( rvm_file, rvm_file.gsub( File.basename(rvm_file), "rvm-#{File.basename(rvm_file)}.tar.gz" ) )
      end
      # Symlink RVM's <version>.tar.gz to rvm-<version>.tar.gz so it's still downloadable
      unless File.exists? "rvm-#{File.basename(rvm_file)}"
        puts "Creating symlink from <version> to rvm-<version>\r\n\r\n"
        File.symlink( rvm_file, "#{File.dirname(rvm_file)}/rvm-#{File.basename(rvm_file)}" )
      end
    end

    # Symlink Rubinius Github download filename to RVM expected filename
    Dir.glob("#{RUBIES_PATH}/rbx/*").each do |rbx_path|
      # Skip the file if it is a symlink, we delete it before creating it l8r
      next if File.symlink?(rbx_path)

      # Determine if we need to create a symlink (any file without -p0)
      unless rbx_path =~ /rubinius-/
        # Determine the symlink to create
        symlink_path = rbx_path.gsub('\/v', 'rubinius-')
        FileUtils.rm symlink_path if File.symlink?(symlink_path)
        puts "Creating symlink for #{rbx_path}"
        puts "symlink_path: #{symlink_path}\r\n\r\n"
        File.symlink( rbx_path, symlink_path )
      end
    end

    # Symlink yaml dir to libyaml or vice-versa for backwards compatibility
    # We don't control the config/rubies.yml which dictates paths, so we'll be
    # dynamic and handle both possible situations. We're nice like that ;)
    if File.exist?(File.expand_path("#{RUBIES_PATH}/packages/yaml"))
      # Create symlink for libyaml
      puts "Creating symlink from yaml to libyaml\r\n\r\n"
      `ln -s #{RUBIES_PATH}/packages/yaml #{RUBIES_PATH}/packages/libyaml`
    elsif File.exist?(File.expand_path("#{RUBIES_PATH}/packages/libyaml"))
      # Create symlink for yaml
      puts "Creating symlink from libyaml to yaml\r\n\r\n"
      `ln -s #{RUBIES_PATH}/packages/libyaml #{RUBIES_PATH}/packages/yaml`
    else
      puts "!"*80
      puts "libyaml / yaml package folder wasn't found, you probably want this to exist for MRI!\r\n\r\n"
    end
  end
end
