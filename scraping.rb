# -*- coding: utf-8 -*-
require "anemone"
require "nokogiri"
require "kconv"
require "csv"

urls = []
urls.push("http://itp.ne.jp/result/?sr=1&nad=1&ad=13105001002&evdc=1&num=50&pg=2")
# urls.push("http://itp.ne.jp/result/?sr=1&nad=1&ad=13105001001&evdc=1&num=50&pg=2")
# urls.push("")
# urls.push("")
# urls.push("")
# urls.push("")
# urls.push("")
# urls.push("")

Anemone.crawl(urls, depth_limit: 0) do |anemone|
  anemone.on_every_page do |page|

  # 文字コードをUTF-8に変換したうえで、Nokogiriでパース
    doc = Nokogiri::HTML.parse(page.body.toutf8)

    names        = doc.xpath("//article/section/h4/a")
    first_items  = doc.xpath("//article/section/p[1]")
    second_items = doc.xpath("//article/section/p[2]")
    third_items  = doc.xpath("//article/section/p[3]")

    names_ary = []
    names.each do |name|
      names_ary << name.text.gsub("複数掲載あり","")
    end

    def molding(str)
      str.strip.gsub(" ","").gsub("住所","").gsub("TEL","").gsub("地図・ナビ","").gsub("くちコミする", "").gsub("お気に入りに登録","").gsub("\n","").gsub("複数掲載あり","")
    end

    first_items_ary = []
    first_items.each do |first_item|
      first_items_ary << molding(first_item.text)
    end

    second_items_ary = []
    second_items.each do |second_item|
      second_items_ary << molding(second_item.text)
    end

    third_items_ary = []
    third_items.each do |third_item|
      third_items_ary << molding(third_item.text)
    end

    # 解析したデータの配列化
    store_info = names_ary.zip(first_items_ary, second_items_ary, third_items_ary)
    puts store_info

    # 配列をcsvに変換
    csv_str = store_info.map { |e| e.to_csv  }

    # CSVファイルの作成
    # now = Time.now.strftime('%Y%M%d')
    file_name = "list.csv"
    File.open("#{file_name}", "a") do |f|
      f.puts csv_str
    end
  end
end

