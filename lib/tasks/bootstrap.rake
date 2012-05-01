require 'yaml'

namespace :boot do

  task :strap do
    # Delete the 'public/rubies' directory to ensure we only download Rubies &
    # packages specified in the rubies.yml file.
    FileUtils.rm_rf File.expand_path("../../../public/rubies", __FILE__)

    # See if we have a custom rubies.yml file, if not use the .example default.
    if File.exist? File.expand_path("../../../config/rubies.yml", __FILE__)
      rubies_yaml_file = File.expand_path("../../../config/rubies.yml", __FILE__)
    else
      rubies_yaml_file = File.expand_path("../../../config/rubies.yml.example", __FILE__)
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
      puts "Creating directory public/rubies/#{params[:path_prefix]}"
      FileUtils.mkdir_p "public/rubies/#{params[:path_prefix]}"
      
      # Download each ruby from params[:url]
      puts "Downloading #{ruby}..."
      `wget --no-check-certificate #{params[:url]} -P public/rubies/#{params[:path_prefix]}`
      puts "Completed download"
      puts ""
      puts ""
    end
  end
  
end
