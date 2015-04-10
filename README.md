# entrospection

This gem is used to graphically demonstrate the quality of prolaag's entropy evaluations.  It comes with two executables entrogen and entrospect. engtrogen is the CLI to several pseudo random number generators. entrospect analyzes and produces a report to describe the quality of how random a data set is.  While entrospect was developed for testing random number sequences, it can evaluate any stream of data. See how random that jpeg of you significant other actually is.

## Installation

Add this line to your application's Gemfile:

    gem 'prolaag-entrospection'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prolaag-entrospection

## Usage

### Generating data sets
 
   Call the entropy generation tool 'entrogen' with the -g switch and redirect the output to a file.

    $ entrogen -g GENERATOR_NAME -l nnn > path-to-file

       GENERATOR   the name of one of the pseudo random number generators provided in the gem. 

       nnn         specifies a limit in bytes to afterwhich the stream terminates.
                   when no limit is provided the generator will stream indefinitely.


### Analysing and Viewing the results

    $ entrospect <path-to-file>

The output of entrospect is a collection of ".png" files and a simple html report that can be opened in a browser. Each ".png" is named for the test that created the chart.

The list of tests.
* binomial
* bit
* byte
* covariance
* gauss_sum
* qindependence
* runs
