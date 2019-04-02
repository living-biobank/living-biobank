# Living Biobank

### Installation Guide

Before installing Gems, you will need to download several files from [Oracle Technology Network](https://www.oracle.com/technetwork/topics/intel-macsoft-096467.html) in order to make the `ruby-oci8` Gem work. (See [this guide](https://github.com/kubo/ruby-oci8/blob/master/docs/install-on-osx.md))

* Instant Client Package - Basic (`instantclient-basic-macos.x64-12.1.0.2.0.zip`) or Basic Lite (`instantclient-basiclite-macos.x64-12.1.0.2.0.zip`)
* Instant Client Package - SDK (`instantclient-sdk-macos.x64-12.1.0.2.0.zip`)
* Instant Client Package - SQL*Plus (`instantclient-sqlplus-macos.x64-12.1.0.2.0.zip`) (optionally)

Install Gems
```
bundle install
```

Install Yarn Packages
```
# Install Yarn unless you already have it
brew install yarn

# Install yarn packages
yarn install
```

Set up your database and sharding configuration
```
cp config/database.yml.example config/database.yml
cp config/sparc_request_database.yml.example config/sparc_request_database.yml
cp config/i2b2_database.yml.example
```

After copying the `.yml.example` files, modify the corresponding `.yml` files with your database and shard configuration.
