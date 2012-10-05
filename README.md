# ArInception

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'ar_inception'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ar_inception

## Usage

Simply surround the block you wish to run at the "base" transaction level like so:

    ActiveRecord::Base.escape_transaction do
        your.code.here
    end

## Build Status

[![Build Status](https://travis-ci.org/zeevex/ar_inception.png)](https://travis-ci.org/zeevex/ar_inception)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
