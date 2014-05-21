# DramUtils

Dramforever Utilties

## Installation

Add this line to your application's Gemfile:

    gem 'dram_utils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dram_utils

## Usage

    require "dram_utils"

    # And run it!
    DramUtils.run!

    # Or use it as a rack middleware
    map("/dram_utils") { run DramUtils.APP }

## Documentation

Just go into the files for documentation, they are pretty clear

## Contributing

1. Fork it ( http://github.com/<my-github-username>/dram_utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
