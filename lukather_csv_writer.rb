require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'

years = 1977..2016

class Artist
  @@artists = []
 
  def self.all
    @@artists
  end

  def self.find_by_name(name)
    all.find { |a| a.name == name }
  end

  attr_accessor :name

  def initialize(name)
    Artist.all << self unless Artist.find_by_name(name)
    @name = name
  end
end

class Year
  @@years = []
  
  def self.all
    @@years
  end

  def self.find(year)
    all.find { |y| y.year = year }
  end

  attr_accessor :year

  def initialize(year)
    Year.all << self
    @year = year
  end
end

class Title
  @@titles = []
  
  def self.all
    @@titles
  end

  def self.find_by_title(title)
    all.find { |t| t.title = title }
  end

  def self.find_by_year(year)
    Title.all.select { |t| t.year == year }
  end

  attr_accessor :artist, :year, :title

  def initialize(title, artist, year)
    Title.all << self
    @title = title
    @artist = artist
    @year = year
  end
end

years.each do |y|
  html = Nokogiri::HTML(open("http://www.stevelukather.com/music/discography/#{y}.aspx"))
  albums = html.css('.discography-title').map { |album| album.inner_text.gsub("\t", "").gsub("\n", "") }
  artists = html.css('.discography-artist').map { |artist| artist.inner_text }
  year = Year.new(y)
  albums.each_with_index do |album, i|
    artist = Artist.new(artists[i])
    tutke = Title.new(album, artist, year)
  end
end

years = File.open('years.csv', 'w')
CSV.open(years, 'w') do |csv|
  Year.all.each do |y|
    csv << [y.year]
  end
end
years.close

artists = File.open('artists.csv', 'w')
CSV.open(artists, 'w', force_quotes: true) do |csv|
  Artist.all.uniq.each do |a|
    csv << [a.name.to_s]
  end
end
artists.close

titles = File.open('titles.csv', 'w')
CSV.open(titles, 'w', force_quotes: true) do |csv|
  Title.all.each do |t|
    csv << [t.title.to_s, t.artist.name.to_s, t.year.year]
  end
end
titles.close

puts "Finished writing #{Year.all.length} years, #{Artist.all.uniq.length} artists, and #{Title.all.length} titles to CSV!"
