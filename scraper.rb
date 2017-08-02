#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

category_names = WikiData::Category.new('Category:Members_of_the_11th_Parliament_of_Kenya', 'en').member_titles

template_names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/w/index.php?title=Special:WhatLinksHere/Template:Current_MPs_of_Kenya&limit=500',
  xpath: '//ul[@id="mw-whatlinkshere-list"]//li//a[not(@class="new")][1]/@title',
).uniq.reject { |n| n.include? ':' }

# Find all P39s of the 11th Parliament
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    BIND(wd:Q17510786 AS ?membership)
    BIND(wd:Q17007305 AS ?term)

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { en: category_names | template_names })

