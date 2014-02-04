# RVM::FW Edition

[![Build Status](https://travis-ci.org/stevenhaddox/rvm_fw.png?branch=master)](https://travis-ci.org/stevenhaddox/rvm_fw) [![Dependency Status](https://gemnasium.com/stevenhaddox/rvm_fw.png)](https://gemnasium.com/stevenhaddox/rvm_fw) [![Code Climate](https://codeclimate.com/github/stevenhaddox/rvm_fw.png)](https://codeclimate.com/github/stevenhaddox/rvm_fw)

RVM::FW works really well to make it possible to use RVM (or rbenv even) inside a restrictive LAN or Firewall just like you do at home.

## Setup RVM::FW

1. Clone RVM::FW:

        $ git clone git://github.com/stevenhaddox/rvm_fw.git
        $ bundle install

2. [Create & modify config/rubies.yml](#adding-more-rubiez).

3. Download Rubiez and packages:  

        $ bundle exec rake boot:strap

4. Archive your local setup of RVM::FW and import it into your network.

5. Deploy! RVM::FW is a simple Sinatra application so you can deploy it anywhere you have Ruby or Rack available internally!

## How to Use RVM::FW Once It's Deployed

[View a demo](http://rvm-fw.herokuapp.com) to see RVM::FW's user views & instructions for how to setup and use RVM internally. Obviously there are no rubies due to file-size / RVM itself existing on the real Internet.

Just visit: `http(s)://<your_host>:<port>/db` to get a plain-text file that your users need to copy and paste into: `~/.rvm/user/db`.  This file overrides the defaults built into RVM's `~/.rvm/config/db` and will point it to your RVM::FW instance to download it's rubies.

You can also visit: `http(s)://<your_host>:<port>/known` to get a plain-text file that a user can be put into: `~.rvm/config/known`. This will provide a more a accurate list of available rubies when a user runs `rvm list known`.

## I Want to Help!

Add your idea or feature requests to the [issue tracker](https://github.com/stevenhaddox/rvm_fw/issues) or [Fork RVM::FW on GitHub](https://github.com/stevenhaddox/rvm_fw) and send me a pull request!

## Easter Egg

**Bonus:** If you're an rbenv fan but still stuck in a restricted environment you can use RVM::FW as a simple way to host a central location to keep your Ruby source code. Accessing your desired version of Ruby for rbenv is as simple as querying `http(s)://<your_host>:<port>/public/rubies/<ruby_platform>/<ruby_specific_path>`. All the Ruby source paths & packages are easily discoverable within the [config/rubies.yml](config/rubies.yml.example) file.

## Adding More Rubiez

We're looking into [rendering the views for db.erb and known.erb dynamically](https://github.com/stevenhaddox/rvm_fw/issues/20) based upon your custom configuration or the default configuration of [config/rubies.yml](config/rubies.yml.example), but until then you have to manually update and maintain the following files:

* customize config/rubies.yml (defaults to: [config/rubies.yml.example](config/rubies.yml.example))
* update [views/db.erb](views/db.erb)
* update [views/known.erb](views/known.erb)

## Special Thanks

Special thanks to [those who've contributed](https://github.com/stevenhaddox/rvm_fw/contributors) and helped me maintain RVM::FW over the years.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/stevenhaddox/rvm_fw/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

