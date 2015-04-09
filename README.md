# entrospection

Used to graphically demonstrate the quality of prolaag's entropy evaluations.  Several pseudo random number generators are provided as part of this gem. However, this tool can evaluate any data set to assess the quality of its randomness.  

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

    $ entrogen -g GENERATOR_NAME > path-to-file

   Let the generator run for some amount of time accumulating data in the file. When you think you have collected sufficient data terminate the generator with CTRL-C.


### Analysing and Viewing the results

    $ entrospect -f <path-to-file>

The output of entrospect is a collection of ".png" files that can be opened individually or are displayed together via the report.html in a browser. Each ".png" is named for the test that create the chart which is that test's assessment of the data set.  See below for the list of tests.

* binomial
* bit
* byte
* covariance
* gauss_sum
* qindependence
* runs
