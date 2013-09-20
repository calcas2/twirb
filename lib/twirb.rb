  require "tk" 
  require "tkextlib/tile"
  $LOAD_PATH <<  './lib'
  require 'keywords'
  require 'manipulation'
  require 'textgui'
  require 'twirb/version'


module Twirb
  class TextEdit < TextGui
    include Manipulation
  end   
end
  
  Twirb::TextEdit.new 
  Tk.mainloop 

