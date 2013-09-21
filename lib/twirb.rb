  require "tk" 
  #require "tkextlib/tile"
  #$LOAD_PATH <<  './lib'
  require 'twirb/keywords'
  require 'twirb/manipulation'
  require 'twirb/textgui'
  require 'twirb/version'


module Twirb
  class TextEdit < TextGui
    include Manipulation
  end   
end
  
  Twirb::TextEdit.new 
  Tk.mainloop 

