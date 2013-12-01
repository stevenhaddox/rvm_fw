require 'yaml'

namespace :boot do

  desc "Download Rubies in config/rubies.yml, keep existing with: $ rake boot:strap KEEP=true"
  task :strap do

    # Set common directory paths as variables for quick referencing
    app_root   = File.expand_path("../../..", __FILE__)
    rubies_dir = File.expand_path("../../../public/rubies", __FILE__)

    # Delete the 'public/rubies' directory to ensure we only download Rubies &
    # packages specified in the rubies.yml file.
    unless ENV["KEEP"]
      FileUtils.rm_rf rubies_dir
    else
      # Nuke rvm package dir due to weird naming convention and avoiding duplicates
      # TODO: Patch downloading dupes and avoid nuking this directory
      FileUtils.rm_rf "#{rubies_dir}/packages/rvm"
    end

    # See if we have a custom rubies.yml file, if not use the .example default.
    if File.exist? File.expand_path("#{app_root}/config/rubies.yml")
      rubies_yaml_file = File.expand_path("#{app_root}/config/rubies.yml")
    else
      rubies_yaml_file = File.expand_path("#{app_root}/config/rubies.yml.example")
      puts "\r\nYou haven't customized config/rubies.yml, installing default RVM::FW Rubies...\r\n\r\n"
      sleep 5
    end

    # I Haz ALL the RUBIES!!!!
    rubies = YAML::load_file(rubies_yaml_file)
    rubies.each do |ruby, params|
      unless File.exist? "#{rubies_dir}/#{params[:path_prefix]}/#{ruby}"
        puts "-"*80
        puts "Starting #{ruby}"
        puts "-"*80

        # Create path from params[:path_prefix]
        puts "Creating directory #{rubies_dir}/#{params[:path_prefix]}\r\n"
        FileUtils.mkdir_p "#{rubies_dir}/#{params[:path_prefix]}"

        # Download each ruby from params[:url]
        puts "Downloading #{ruby}..."
        `wget --no-check-certificate #{params[:url]} -P #{rubies_dir}/#{params[:path_prefix]}`
        puts "Completed download\r\n\r\n\r\n"
      else
        puts "-"*80
        puts "Skipping #{ruby}..."
        puts "File already exists: #{rubies_dir}/#{params[:path_prefix]}/#{ruby}"
        puts "-"*80
        puts "\r\n\r\n"
      end
    end

    # Rename rvm packages to fit old script naming style:
    Dir.glob(File.expand_path("#{rubies_dir}/packages/rvm/*")).each do |rvm_file|
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

    # Symlink yaml dir to libyaml or vice-versa for backwards compatibility
    # We don't control the config/rubies.yml which dictates paths, so we'll be
    # dynamic to handle both possible situations. We're nice like that ;)
    if File.exist?(File.expand_path("#{rubies_dir}/packages/yaml"))
      # Create symlink for libyaml
      puts "Creating symlink from yaml to libyaml\r\n\r\n"
      `ln -s #{rubies_dir}/packages/yaml #{rubies_dir}/packages/libyaml`
    elsif File.exist?(File.expand_path("#{rubies_dir}/packages/libyaml"))
      # Create symlink for yaml
      puts "Creating symlink from libyaml to yaml\r\n\r\n"
      `ln -s #{rubies_dir}/packages/libyaml #{rubies_dir}/packages/yaml`
    else
      puts "!"*80
      puts "libyaml / yaml package folder wasn't found, you probably want this to exist for MRI!\r\n\r\n"
    end
    `cd #{app_root}`

  end

end
