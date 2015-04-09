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


### Analysing and Viewing the results

    $ entrospect -f <path-to-file>

The output of entrospection are a number of ".png"s that can be opened individually or are displayed together via the report.html in a browser.

* binomial.png
* bit.png
* byte.png
* covariance.png
* gauss_sum.png
* qindependence.png
* runs.png
