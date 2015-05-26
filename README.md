# RVM::FW Edition

[![Build Status](https://travis-ci.org/stevenhaddox/rvm_fw.png?branch=master)](https://travis-ci.org/stevenhaddox/rvm_fw) [![Dependency Status](https://gemnasium.com/stevenhaddox/rvm_fw.png)](https://gemnasium.com/stevenhaddox/rvm_fw) [![Code Climate](https://codeclimate.com/github/stevenhaddox/rvm_fw.png)](https://codeclimate.com/github/stevenhaddox/rvm_fw)[![endorse](https://api.coderwall.com/stevenhaddox/endorsecount.png)](https://coderwall.com/stevenhaddox)

RVM::FW works really well to make it possible to use RVM (or rbenv even) inside a restrictive LAN or Firewall just like you do at home.

## Setup RVM::FW

1. Clone RVM::FW:

        $ git clone git://github.com/stevenhaddox/rvm_fw.git
        $ bundle install
        # For Ruby < 1.9.3 RVM::FW runs in production mode only:
        $ bundle install --without development test

2. [Create & modify config/rubies.yml](#adding-more-rubiez).

3. Download Rubiez and packages:  

        $ bundle exec rake boot:strap

Or, to keep pre-downloaded Rubies and just add to them:

        $ KEEP=true bundle exe rake boot:strap

4. Archive your local setup of RVM::FW and import it into your network.

5. Deploy! RVM::FW is a simple Sinatra application so you can deploy it anywhere you have Ruby or Rack available internally!

## How to Use RVM::FW Once It's Deployed

[View a demo](http://rvm-fw.herokuapp.com) to see RVM::FW's user views & instructions for how to setup and use RVM internally. Obviously there are no rubies due to file-size / RVM itself existing on the real Internet.

Just visit: `http(s)://<your_host>:<port>/db` to get a plain-text file that your users need to copy and paste into: `~/.rvm/user/db`.  This file overrides the defaults built into RVM's `~/.rvm/config/db` and will point it to your RVM::FW instance to download it's rubies.

You can also visit: `http(s)://<your_host>:<port>/known` to get a plain-text file that a user can be put into: `~.rvm/config/known`. This will provide a more a accurate list of available rubies when a user runs `rvm list known`.

## Easter Egg

**Bonus:** If you're an rbenv fan but still stuck in a restricted environment you can use RVM::FW as a simple way to host a central location to keep your Ruby source code. Accessing your desired version of Ruby for rbenv is as simple as querying `http(s)://<your_host>:<port>/public/rubies/<ruby_platform>/<ruby_specific_path>`. All the Ruby source paths & packages are easily discoverable within the [config/rubies.yml](config/rubies.yml.example) file.

## Adding More Rubiez

We're looking into [rendering the views for db.erb and known.erb dynamically](https://github.com/stevenhaddox/rvm_fw/issues/20) based upon your custom configuration or the default configuration of [config/rubies.yml](config/rubies.yml.example), but until then you have to manually update and maintain the following files:

* customize config/rubies.yml (defaults to: [config/rubies.yml.example](config/rubies.yml.example))
* update [views/db.erb](views/db.erb)
* update [views/known.erb](views/known.erb)

Any rubies that are found in `/public/rubies` will be rendered dynamically in the `/rubies` route on the site. The MD5 sums will also be calculated dynamically to ensure users can compare original MD5s vs possibly modified RVM::FW MD5s.

## Enterprise Concerns

I've recently hit an issue when trying to import certain rubies into my corporate environment. The virus scanner fails on several files. I've tried to add these files to a flagged_file list in the config folder and written a bash script that will remove those files and repackage the ruby. All of these files seem Rdoc or test related thus far so the only real con is that the MD5 sum of the file changes, but at least it allows for automated importing of rubies for those who may hit similar issues with either the ClamAV or McAfee Enterprise virus scanners.

To remove these files from your packages be sure to add any files you need to your `config/flagged_files.txt` file unless you are only using the default rubies.yml file. Then run:

        $ ./scripts/enterprisify.sh

This process will take a while as it has to extract each ruby / package file, scan for matching flagged files, remove them and then re-compress or restore the original file as needed.

# Development

## CSS Styles

Stylesheets are handled via the gems: `bootstrap-sass` && `compass`.

To update bootstrap, update the version of `bootstrap-sass` and run `bundle update`

If you modfy the variables (`sass/_boostrap_variables.scss`) or the main application styles (`sass/_rvmfw.scss`) then be sure to update the generated CSS files with the appropriate environment command:

```
$ bundle exec compass compile --output-style compressed -e production
$ bundle exec compass compile --output-style nested -e development
```

## I Want to Help!

Add your idea or feature requests to the [issue tracker](https://github.com/stevenhaddox/rvm_fw/issues) or [Fork RVM::FW on GitHub](https://github.com/stevenhaddox/rvm_fw) and send me a pull request!

## Special Thanks

Special thanks to [those who've contributed](https://github.com/stevenhaddox/rvm_fw/contributors) and helped me maintain RVM::FW over the years.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/stevenhaddox/rvm_fw/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
