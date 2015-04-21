# entrospection

This gem includes tools to graphically describe the statistical qualities of random number generators.

## Installation

Add this line to your application's Gemfile:

    gem 'entrospection'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install entrospection

## Usage

### Included sample generators
 
   Call the entropy generation tool 'entrogen' with a the name of a generator and redirect the output to a file.

    $ entrogen GENERATOR_NAME -l nnn > path-to-file

       GENERATOR   the name of one of the pseudo random number generators provided in the gem. 

       nnn         specifies a limit in bytes to afterwhich the stream terminates.
                   when no limit is provided the generator will stream indefinitely.


### Analysing and Viewing the results
    Either call entrospect and provide the name of a file
    
    $ entrospect <path-to-file>
    
    or use entrogen to generate a stream that is piped into entrogen
    
    $ entrogen md5 -l 10485760 | entrospect

The output of entrospect is a collection of ".png" files and a simple html report that can be opened in a browser. Each ".png" is named for the test that created the chart.
