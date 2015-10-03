#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'

@pages = [
  'Category:Members_of_the_11th_Parliament_of_Kenya'
]

@pages.map { |c| WikiData::Category.new(c, 'en').wikidata_ids }.flatten.uniq.each do |id|
  data = WikiData::Fetcher.new(id: id).data or next
  ScraperWiki.save_sqlite([:id], data)
end
