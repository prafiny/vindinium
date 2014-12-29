Setting up the environment
=======
PolyBot lies on rubinius and uses a few gems to work properly. Therefore, you'll need working copies from both *rubygems* and *rubinius*

It can run on GNU/Linux, BSD and Mac OS X

Make sure your OS is equipped with a Terminal Client and curl.

Installing Rubinius with RVM
------

First, we need to install RVM (method from <https://rvm.io/>).

Fetch RVM's GPG key

    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

Get it installed by wget/sh script

    \curl -sSL https://get.rvm.io | bash -s stable

RVM is a tool to manage ruby interpreters, we can install Rubinius with it.

    rvm install rbx
    rvm use rbx

Installing vindinium client's dependencies with rubygems and bundler
------
Then, we have to install all the libraries needed for the client and bot to work

Install rubygems by the following command line

    rvm rubygems current

Install the bundler tool

    gem install bundler

Execute dependencies installation

    bundle install
    
Script to do all the stuff
-----

    #!/bin/sh
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable
    rvm install rbx
    rvm use rbx
    rvm rubygems current
    bundle install
