# -*- coding: utf-8 -*-
require "anemone"

# クロールの起点となる URL を指定
urls = [
        "http://www.amazon.co.jp/gp/bestsellers/books/",
        "http://www.amazon.co.jp/gp/bestsellers/digital-text/2275256051"
       ]

Anemone.crawl(urls, depth_limit: 1, skip_query_strings: true) do |anemone|

  # 巡回の絞り込み
  anemone.focus_crawl do |page|
    page.links.keep_if { |link|
      link.to_s.match(%r!/gp/bestsellers/books|gp/bestsellers/digital-text!)
    }
  end

  # 取得したページに対する処理
  PATTERN = %r[466298\/+|466282\/+|229165705\+|2291905051\/+]

  anemone.on_pages_like(PATTERN) do |page|
    puts page.url
  end
end