# -*- coding: utf-8 -*-
require "anemone"
require "nokogiri"
require "kconv"
require "csv"

otsuka    = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105001"
# nishikata = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105011"
# yushima   = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105019"
# kouraku   = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105005"
# kasuga    = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105003"
# suido     = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105007"
# kohinata  = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105006"
# sekiguchi = "http://itp.ne.jp/result/?nad=1&sr=1&ad=13105008"

urls = []
urls.push(otsuka)
# urls.push(nishikata)
# urls.push(yushima)
# urls.push(kouraku)
# urls.push(kasuga)
# urls.push(suido)
# urls.push(kohinata)
# urls.push(sekiguchi)

Anemone.crawl(urls, depth_limit: 0, skip_query_skip: true) do |anemone|
  anemone.on_every_page do |page|

  # 文字コードをUTF-8に変換したうえで、Nokogiriでパース
    doc = Nokogiri::HTML.parse(page.body.toutf8)

    names        = doc.xpath("//a[@class=\"blueText\"]")
    first_items  = doc.xpath("//article/section/p[1]")
    second_items = doc.xpath("//article/section/p[2]")
    third_items  = doc.xpath("//article/section/p[3]")

    names_ary = []
    names.each do |name|
      names_ary << name.text
    end

    first_items_ary = []
    first_items.each do |first_item|
      first_items_ary << first_item.text
    end

    second_items_ary = []
    second_items.each do |second_item|
      second_items_ary << second_item.text
    end

    third_items_ary = []
    third_items.each do |third_item|
      third_items_ary << third_item.text
    end
    store_info = names_ary.zip(first_items_ary, second_items_ary, third_items_ary)
  end
end