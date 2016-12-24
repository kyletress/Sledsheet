class Article < ApplicationRecord

  validates :title, uniqueness: true

  def self.get_new
    page = Nokogiri::HTML(open('http://www.slidingonice.com/?cat=7'))
    page.css('article.type-post').each do |item|
      article = from_slidingonice(item)
      article.save
    end
  end

  def self.from_slidingonice(item)
    full_title = item.css('h3.entry-title').text
    result = full_title.gsub /\t/, ''
    clean_title = result.gsub /\n/, ''
    article = Article.new(
      title: clean_title,
      link: item.css("h3.entry-title > a").attribute('href').value,
      description: item.css('.mh-excerpt').text.gsub(/\n/, ''),
      source: "Sliding On Ice"
    )
  end

  def self.from_espn
  end

  def self.from_cbc
  end

  def self.from_nbc
  end

  def self.from_ibsf
  end

  def self.from_bbc
  end

  def self.from_reddit
  end
end
