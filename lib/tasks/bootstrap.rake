require 'yaml'

namespace :boot do

  task :strap do

    # Set common directory paths as variables for quick referencing
    app_root   = File.expand_path("../../..", __FILE__)
    rubies_dir = File.expand_path("../../../public/rubies", __FILE__)

    # Delete the 'public/rubies' directory to ensure we only download Rubies &
    # packages specified in the rubies.yml file.
    #FileUtils.rm_rf File.expand_path("../../../public/rubies", __FILE__)
    FileUtils.rm_rf rubies_dir

    # See if we have a custom rubies.yml file, if not use the .example default.
    if File.exist? File.expand_path("#{app_root}/config/rubies.yml")
      rubies_yaml_file = File.expand_path("#{app_root}/config/rubies.yml")
    else
      rubies_yaml_file = File.expand_path("#{app_root}/config/rubies.yml.example")
      puts ""
      puts "You haven't customized config/rubies.yml, installing default RVM::FW Rubies..."
      puts ""
      sleep 5
    end

    # I Haz ALL the RUBIES!!!!
    @rubies = YAML::load_file(rubies_yaml_file)
    @rubies.each do |ruby, params|
      puts "-"*80
      puts "Starting #{ruby}"
      puts "-"*80
      
      # Create path from params[:path_prefix]
      puts "Creating directory public/rubies/#{params[:path_prefix]}\r\n"
      FileUtils.mkdir_p "public/rubies/#{params[:path_prefix]}"
      
      # Download each ruby from params[:url]
      puts "Downloading #{ruby}..."
      `wget --no-check-certificate #{params[:url]} -P public/rubies/#{params[:path_prefix]}`
      puts "Completed download\r\n\r\n\r\n"
    end

    # Rename rvm packages to fit old script naming style:
    Dir.glob(File.expand_path('#{rubies_dir}/packages/rvm/*')).each do |rvm_file|
      unless File.basename(rvm_file).include? '.tar.gz'
        puts "Renaming #{File.basename(rvm_file)} to rvm-#{File.basename(rvm_file)}.tar.gz\r\n\r\n"
        File.rename( rvm_file, rvm_file.gsub( File.basename(rvm_file), "rvm-#{File.basename(rvm_file)}.tar.gz" ) )
      end
    end

    # Symlink yaml dir to libyaml or vice-versa for backwards compatibility
    # We don't control the config/rubies.yml which dictates paths, so we'll be
    # dynamic to handle both possible situations. We're nice like that ;)
    if File.exist?(File.expand_path("#{rubies_dir}/packages/yaml"))
      # Create symlink for libyaml
      puts "Creating symlink from #{rubies_dir}/packages/yaml to #{rubies_dir}/packages/libyaml\r\n\r\n"
      `ln -s #{rubies_dir}/packages/yaml #{rubies_dir}/packages/libyaml`
    elsif File.exist?(File.expand_path("#{rubies_dir}/packages/libyaml"))
      # Create symlink for yaml
      puts "Creating symlink from #{rubies_dir}/packages/libyaml to #{rubies_dir}/packages/yaml\r\n\r\n"
      `ln -s #{rubies_dir}/packages/libyaml #{rubies_dir}/packages/yaml`
    else
      puts "!"*80
      puts "libyaml / yaml package folder wasn't found, you probably want this to exist for MRI!\r\n\r\n"
    end

  end
  
end
