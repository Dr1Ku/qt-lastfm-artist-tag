# Inspiration: https://github.com/bdefore/iTunes-Multi-Genre-Tagger/blob/master/imgt.rb
# cd /d M:\!!!##Y'ALL SORT THIS HERE MUZ\##DONE\2006 - Stop the clocks

#03.08.2008

def load_dependencies_dir(p_dir, p_dependencies)
	p_dependencies.map { |dependency| begin require "#{p_dir}/#{dependency}"; rescue LoadError => e; pp e; exit; end }
end

require "rubygems"
require "pp"

# Dependencies
load_dependencies_dir("util", %W{ settings consts utils dir_scanner }) # Utils
load_dependencies_dir("model", %W{ album artist artist_cache })	# Model
load_dependencies_dir("lib", %W{ id3_lite_wrapper last_fm_tag_retriever }) # Library wrappers

# Initialize directory scanner
paths = DirScanner.new("M:/!!!##Y'ALL SORT THIS HERE MUZ/##DONE/", ".mp3").list

# Initialize artist cache
cache = ArtistCache.new

# Iterate through each found path
paths.each_with_index do |path, i|

	# Read ID3 Tags for the given file
	id3 = ID3LiteWrapper.new(path)
	
	# Log current file's directory, if not already retrieved
	STDERR.puts(File.dirname(path))
	
	artist = Artist.new(id3)	
	album = Album.new(id3, File.dirname(path), artist)

	cache << artist
end

puts cache

#a_path = paths[0]
#pp a_path, a_path.slice(0..a_path.rindex("/") - 1)
#id3 = ID3LiteWrapper.new("M:/!!!##Y'ALL SORT THIS HERE MUZ/##DONE/2006 - Stop the clocks/CD2/Oasis - 05 - Go let it out.mp3")#(a_path)
#pp id3.genre.gsub("\000", ""), id3.grouping, id3.album, id3.year
#artist = Artist.new(id3)
#last = LastFMTagRetriever.new(artist).execute
#id3.add_tags_for(artist)