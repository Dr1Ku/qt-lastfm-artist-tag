# Class description
module Consts

  # Public declarations
  public

    LOG_PREFIX = "qt-lastfm-artist-tag".freeze

    EXIT_CODES = { :lastfm_timed_out => -2, :dependency_not_found => -1, :all_fine => 0 }.freeze

    VALUE_PLACEHOLDERS = { :artist => "Unknown Artist", :album => "Others", :generic => "Unknown" }.freeze
    MESSAGES 	 = { :lastfm_timed_out => "last.fm API Request timed out! Trying again. . . ",
							 :check_network_connection => "Fatal Error: Either the last.fm API is down, or you are not connected to the Internet (check your network connection). Sorry, exiting!" }.freeze

    MP3_MASK = "*.mp3".freeze

end # class Consts
