#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'
require 'pry'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def wikinames(url)
  noko = noko_for(url)
  noko.xpath('//table[.//th[contains(.,"Representative-elect")]]//tr[td]').map { |tr| tr.css('td')[-2].xpath('.//a[not(@class="new")]/@title').text }.uniq
end

names = wikinames('https://en.wikipedia.org/wiki/Kenya_National_Assembly_elections,_2013')

WikiData.ids_from_pages('en', names).each_with_index do |p, i|
  data = WikiData::Fetcher.new(id: p.last).data('fr') rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  ScraperWiki.save_sqlite([:id], data)
end
