require 'yaml'

namespace :boot do
  task :strap do
    @rubies = YAML::load_file('config/rubies.yml')
    @rubies.each do |ruby, params|
      puts ""
      puts "-"*20
      puts "Starting #{ruby}"
      
      #create path from params[:path_prefix]
      puts "Creating directory public/rubies/#{params[:path_prefix]}"
      FileUtils.mkdir_p "public/rubies/#{params[:path_prefix]}"
      
      #download each ruby from params[:url]
      puts "Downloading #{ruby}..."
      `wget #{params[:url]} -P public/rubies/#{params[:path_prefix]}`
      puts "Completed download"
    end
  end
end
