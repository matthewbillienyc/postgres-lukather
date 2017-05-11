require 'nokogiri'
require 'open-uri'

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

