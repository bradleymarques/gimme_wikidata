# GimmeWikidata

A Ruby gem to search and receive (and, in future create) data on the [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page) open knowledge base.

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

```
search = GimmeWikidata.search('David Bowie');
```

This will return a `Search` object, which you can use like:

```
search.was_successful?
  => true

search.search_term
  => "David Bowie"

search.results.count
  => 7

search.top_result.id
  => "Q5383"
```

### Get Data from Wikidata

You could use the search results above to get more data about an `Item` (identtified by an `id`):

```
entities = GimmeWikidata.fetch(["Q5383", "Q1"])
result.entities # Will return a collection of the Entities grabbed from Wikidata
```

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
