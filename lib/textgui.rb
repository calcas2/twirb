  #require "./keywords" 
  
  class TextGui 
    include Keywords 
    def initialize 
      setup 
      @auto_highlight = true 
      #@mod = [] 
      #@list = [] 
      @div = []
      @style_font = TkFont.new('helvetica 14') 
      var = TkVariable.new 
      status = TkVariable.new 
      root = TkRoot.new 
      root.title = "new file" 
      $scroll = Tk::Tile::Scrollbar.new(root) {orient 'vertical'; 
      command proc {|*args| 
      $entr.yview(*args)}}.grid :column => 2, :row => 0, :sticky => 'ns' 
      $entr = @entry = TkText.new(root) {undo true;width 80;height 14;wrap 'none'; 
      yscrollcommand(proc{|first, last| $scroll.set(first, last)}) }.grid :column => 0, :row => 0, :columnspan => 2, :sticky => 'nwes' 
      @lbl = Tk::Tile::Label.new(root) {textvariable; 
      anchor 'w'}.grid :column => 0, :row => 1, :sticky => 'we' 
      @lbl['textvariable'] = var 
      #@lbl.grid('row' => 1, 'column' => 1) 
      @lbl_sin = Tk::Tile::Label.new(root) {textvariable; 
      anchor 'w'}.grid :column => 1, :row => 1, :sticky => 'we' 
      
      sz = Tk::Tile::SizeGrip.new(root).grid :column => 2, :row => 1, :sticky => 'se' 
      TkGrid.columnconfigure root, 0, :weight => 1 
      TkGrid.rowconfigure root, 0, :weight => 1 
      
      ########### 
      @lbl_sin['textvariable'] = status 
      m = TkTextMark.new(@entry, '1.0') 
      @entry.font = @style_font
      configure_text 
      @edit_mode = true 
      command_keyboard(var, status, m) 
      root.bind("Control-Key-o", proc {open_file(root)}) 
      root.bind("Control-Key-s", proc {save_file(root, status)}) 
    end 
    
    def execute_code 
      @t = @entry.value 
      @t.gsub!(/^\d*\)/, "") 
      begin 
        print " => ", eval(@t).inspect, "\n" 
      rescue Exception => e 
        print e.inspect, "\n" 
      end 
    end 
    
    def open_file(root) 
      @file = Tk.getOpenFile 
      begin 
        a = File.read(@file) 
        root.title = @file 
      rescue 
        a = "" 
        @file = nil 
      end 
      @entry.delete('1.0', 'end') if @file 
      @entry.insert('end', "#{a}") if @file 
    end 
    
    def command_keyboard(var, status, m) 
      @entry.bind("Key", proc do 
        var.value = @entry.index(m) 
        status.value = "auto mode" if @edit_mode and @auto_highlight 
      end) 
      @entry.bind("Double-Key-Escape", proc {@edit_mode = true}) 
      @entry.bind("Escape", proc {status.value = "edit mode"; @edit_mode = false}) 
      @entry.bind("Double-Key-Return", proc {new_line}) 
      @entry.bind("Key-Return", proc do |e| 
        e.widget.callback_continue unless @edit_mode 
        highlight 
      end) 
      @entry.bind("Control-Key-q", proc {convert;status.value = "text mode" unless @auto_highlight}) 
      @entry.bind("Control-Key-w", proc {@auto_highlight = true}) 
      @entry.bind("Control-Key-e", proc {execute_code}) 
      @entry.bind("space", proc do |e| 
        #e.widget.callback_break if @auto_highlight 
        e.widget.callback_continue unless @edit_mode 
        highlight 
      end) 
    end 
    
    def configure_text
      %w{blue yellow brown red green violet grey90 DarkOrange}.each do |color| 
        @entry.tag_configure(color, :foreground => color) 
      end
      @entry.tag_configure('grey', :background => 'grey', :relief => 'raised') 
      @entry.tag_configure('black', :background => 'white', :relief => 'raised') 
    end 
    
    def save_file(root, status) 
      @txtt = @entry.value 
      @txtt.gsub!(/^\d*\)/, "") 
      if @file 
        File.open(@file, "w") do |f| 
          f.puts @txtt 
        end 
        status.value = "saved"
      else 
        @file = Tk.getSaveFile 
        begin 
          File.open(@file, "w") do |f| 
            f.puts @txtt 
          end 
          root.title = @file 
        rescue 
          root.title = "new file" 
          @file = nil 
        end 
      end 
    end
  end  
