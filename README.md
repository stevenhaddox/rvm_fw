# RVM::FW Edition

[![Build Status](https://travis-ci.org/stevenhaddox/rvm_fw.png?branch=master)](https://travis-ci.org/stevenhaddox/rvm_fw) [![Dependency Status](https://gemnasium.com/stevenhaddox/rvm_fw.png)](https://gemnasium.com/stevenhaddox/rvm_fw) [![Code Climate](https://codeclimate.com/github/stevenhaddox/rvm_fw.png)](https://codeclimate.com/github/stevenhaddox/rvm_fw)

RVM::FW is meant to be a simple Sinatra application that you can easily deploy on an intranet/local network server and enable quick and easy access to install multiple ruby versions side-by-side the way RVM does at home.

## Setting up RVM::FW

### Download Rubies to Serve to RVM

Once you have RVM::FW downloaded locally you need to download the rubies that you want to serve (probably before you deploy if you're behind a firewall).  In order to do this simply run:

    $ rake boot:strap

## Deploy

The application comes pre-configured to work with Phusion Passenger easily.  Overall it's just a simple Sinatra application so feel free to customize as needed and push it all to your server (just make sure the ruby installs are included in your deploy).

## Configuring RVM to work with RVM::FW

Just visit: http://[your-server]/db to get a plain-text file that your users need to copy and paste into: `~/.rvm/user/db`.  This file overrides the defaults built into RVM's `~/.rvm/config/db` and will point it to your RVM::FW instance to download it's rubies.

You can also visit: http://[your-server]/known to get a plain-text file that a user can be put into: `~.rvm/config/known`. This will provide a more a accurate list of available rubies when a user runs `rvm list known`.

## Adding more rubies

To add more rubies you must:

* update views/db.erb
* update views/known.erb
* update config/rubies.yml.example

One day it would be nice to make this all tied together a bit better. Hopefully we can automate the rendering of db.erb and known.erb dynamically based upon your custom configuration or the default configuration of [config/rubies.yml](config/rubies.yml.example).

# I could benefit from RVM::FW - How do I help?

Fork away and start hacking on any of our [open issues](http://github.com/stevenhaddox/rvm_fw/issues).
