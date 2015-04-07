# entrospection

Used to graphically demonstrate the quality of prolaag's entropy evaluations.

## Installation

Add this line to your application's Gemfile:

    gem 'entrospection'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install entrospection

## Usage

Create a data set from one of the random number routines, described below, or provide your own data set for evaluation. 


    $ entrospection <path-to-file>

## Viewing the results

The output of entrospection are a number of ".png"s that can be opened individually or are displayed together via the report.html in a browser.

* binomial.png
* bit.png
* byte.png
* covariance.png
* gauss_sum.png
* qindependence.png
* runs.png

### Generating a data set

  Several very simple random number generators have been provided.  Each script produces a stream that can be redirected to a file and then evaluated by entrospection.

* aes_ecb.rb

    generates a pseudo-random sequence by encrypting a simple counter with AES in ECB mode

* counter.rb

    interleaves a counter into the stream of random bytes
    
* lcg.rb

    LCG (Linear congruential generator) pseudo-random number generator

* md5.rb

    creates a pseudo-random sequence by MD5-hashing an integer counter

* murmur2.rb

    pseudo-random sequence by Murmur2-hashing an integer counter

* pruned_byte.rb

    MD5 hash that produces a byte pattern that appears 15% less often than its counterparts

* upward.rb

    a pseudo-random sequence created by MD5-hashing an integer counter, but nudges 0.5% of the bytes updwards to produce demonstrable skew
