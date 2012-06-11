# Canvas

[Canvas](https://github.com/instructure/canvas-lms) on Github

## Install Canvas with Chef and Vagrant

### Install Vagrant
Grep your os specific package from [Vagrant](http://downloads.vagrantup.com/).
Or as alternative (though the previous method is preferred).

    gem install vagrant (or use the supplied .rvmrc file when using RVM)

### Checkout and start VM

    git clone https://github.com/zilverline/chef-canvas.git
    git submodule init
    git submodule update
    vagrant up

The directory `shared` is mapped to the shared folder in the vagrant home dir.
It contains a file `runlist.json` which can be used when Vagrant has started the vm.

    vagrant ssh
    sudo chef-solo -j shared/runlist.json

After the VM is running and all the Chef Cookbooks ran you could suspend your vm.

    vagrant suspend

And to start the vm again

    vagrant resume

### Start canvas
After the vm has started and the cookbooks ran you should be able to start canvas `cd /opt/canvas;RAILS_ENV=test scripts/server` and access it on [http://localhost:3000](http://localhost:3000).

## Improvements/todo

* Install under a different user (currently root)
* Do we really need the coffeescript recipe?
* Whole word grep in user and db exists functions
* Can execute resource be used instead of bash in db.rb
* Make the environment a variable in attributes
* Maybe add a not_if to fill database intial_setup of db
* Security possibility to randomize encryption_key
* Security.yml encryption_key is overwritten (only test??)
* Add more CPUs to Vagrant
* Config: delayed-jobs, file-store, ext_migration

## Reference

* [Vagrant](http://vagrantup.com)
* [Chef](http://www.opscode.com/chef)
