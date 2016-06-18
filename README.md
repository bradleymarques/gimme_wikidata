[![Gem Version](http://img.shields.io/gem/v/gimme_wikidata.svg?style=flat-square)](https://rubygems.org/gems/gimme_wikidata)
[![Coverage Status](https://coveralls.io/repos/github/bradleymarques/gimme_wikidata/badge.svg?branch=master)](https://coveralls.io/github/bradleymarques/gimme_wikidata?branch=master)
[![Inline docs](http://inch-ci.org/github/bradleymarques/gimme_wikidata.svg?branch=master)](http://inch-ci.org/github/bradleymarques/gimme_wikidata)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://bradleymarques.mit-license.org)

![alt text](https://raw.githubusercontent.com/bradleymarques/gimme_wikidata/master/img/gimme_wikidata_logo.png "Gimme Wikidata")

Search and get data from the [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page) open knowledge base.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gimme_wikidata'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gimme_wikidata

## Usage

### Search Wikidata

```ruby
search = GimmeWikidata.search('David Bowie');

search.was_successful?
  => true

search.search_term
  => "David Bowie"

search.results.count
  => 7

search.top_result
=> #<GimmeWikidata::SearchResult:0x00555df75cdaa0
    @description="British musician, actor, record producer and arranger",
    @id="Q5383",
    @label="David Bowie",
    @type=GimmeWikidata::Item>
```

### Get Data from Wikidata

You could use the search results above to get more data about an `Item` (identified by an `id`):

```ruby
david_bowie = GimmeWikidata.fetch('Q5383')

david_bowie.aliases
=> ["David Robert Jones", "Ziggy Stardust", "David Jones", "Bowie"]

david_bowie.print
===================
David Bowie (Q5383)
===================
Description British musician, actor, record producer and arranger
Aliases   David Robert Jones, Ziggy Stardust, David Jones, Bowie
Claims:
instance of: human (Q5)
sex or gender: male (Q6581097)
place of birth: Brixton (Q146690)
spouse: Iman (Q256531)
spouse: Angela Bowie (Q2669959)
VIAF ID: 79021253
GND ID: 118514091
SUDOC authorities: 026748363
LCAuth ID: n81112099
BnF ID: 11893660s
discography: David Bowie discography (Q1173801)
Commons category: David Bowie
ISNI: 0000 0001 1444 8576
ISNI: 0000 0003 6858 7082
ISNI: 0000 0003 6858 7074
occupation: painter (Q1028181)
occupation: singer-songwriter (Q488205)
occupation: guitarist (Q855091)
occupation: saxophonist (Q12800682)
occupation: composer (Q36834)
occupation: film actor (Q10800557)
occupation: record producer (Q183945)
occupation: songwriter (Q753110)
occupation: actor (Q33999)
# ... etc

```

## Retrieving Multiple Entities

TODO: DOCUMENT

### Publish

Please note that the GimmeWikidata gem does not currently support publishing data to Wikidata.

### Advanced usage

## The Data Model

The GimmeWikidata gem mirrors the main components of the [Wikidata data model](https://www.mediawiki.org/wiki/Wikibase/DataModel/Primer).  Specifically, the following ideas are encapsulated in classes in this gem:

+ `Entity`
  + `Item`
  + `Property`
+ `Claim`
+ `Snak`

## Contributing

Please feel free to contribute:

+ Fork the repo
+ Make your own bugfix/feature branch
+ Make tests for your contribution
+ Submit a pull request

Alternatively, please feel free to make suggestions.

## License

The MIT License (MIT)

Copyright (c) 2016 Bradley Marques

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
