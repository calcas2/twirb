  module Manipulation

    def add(word, color = "no color")
      @entry.send("insert", 'end', word, color) 
      yield if block_given?
    end

    def delete(num1, num2)
      @entry.send("delete", "end -1 lines + #{num1} chars", "end -1 lines + #{num2} chars")
    end

    def total_delete
      @entry.send("delete", "1.0", "end")
    end

    def interpolate(word) 
      @interpolation << word if word == '#{'
      @interpolation.pop if word == '}'
    end
    
    def method_missing(method, *args)
      end_array = {"literal_array" => "}", "literal_array_square" => "]", "literal_array_parenthesis" => ")"}
      if args[0] == end_array[method.to_s] && @interpolation.empty?
        @keywords[args[0]].call(args[0], args[1], args[2])
      else
        add(args[0], 'violet') {@literal_array_parenthesis << args[0] if args[0] == "(" and @interpolation.empty? and method.to_s == "literal_array_parenthesis"}
        interpolate(args[0])
      end
    end
    
    def comments_multiline(word, i, ind) 
      if word != "=end"
        @keywords["=begin"].call(word, i, ind) 
      else
        @keywords["=end"].call(word, i, ind) 
      end
    end
    
    def single_quote(word, i, ind) 
      #if /\$*\'/.eql?(word) 
if word == "'" || word == "$'" || word == "?'"
        @single_quote.clear 
        add(word, 'violet') 
      else
        @keywords["'"].call(word, i, ind) 
      end 
    end 
    
    def regex(word, i, ind) 
      if word == '/' || word == "?/" and @interpolation.empty?
        @regex.clear
        add(word, 'violet') 
      else
        add(word, 'violet') 
        interpolate(word)
      end 
    end 
    
    
    def double_quote(word, i, ind) 
      #if /%*"/.eql?(word) and @interpolation.empty?
if word == '"' || word == '%"' || word == '?"' and @interpolation.empty?
        @double_quote.clear 
        add(word, 'violet') 
      else 
        #@keywords['"'].call(word, i, ind) 
        add(word, "violet")
        interpolate(word)
      end 
    end 
    
    def comments(word, i, ind) 
      @keywords["#"].call(word, i, ind) 
    end 
    
    def multiline_str(word, i, ind)
      @multiline_str[0][2] != "-" ? @end_str = @multiline_str[0][2..@multiline_str[0].length] : @end_str = @multiline_str[0][3..@multiline_str[0].length] 
      if word == @end_str.gsub(/["\']/, "") && i == 0 && ind == 0 
        add(word, 'violet') 
        @multiline_str.clear
        @start_multiline_str.shift 
      else 
        add(word, 'violet') 
      end 
    end 
    
    def delimiter_multi_str(word, i, ind) 
      @end_multi_str = @delimiter_multi_str[0][@delimiter_multi_str[0].length - 1]
      if word == @end_multi_str 
        add(word, 'violet') 
        @delimiter_multi_str.clear
      else 
        add(word, 'violet') 
      end 
    end 
    
    def delimiter_multi_arr(word, i, ind) 
      @end_multi_arr = @delimiter_multi_arr[0][2]
      if word == @end_multi_arr 
        add(word, 'violet') 
        @delimiter_multi_arr.clear
      else 
        add(word, 'violet') 
      end 
    end 
    
    def instances_for_different_color
      %w{@literal_array @double_quote @single_quote @regex @comments @multiline_str @comments_multiline @delimiter_multi_str @delimiter_multi_arr @literal_array_square @literal_array_parenthesis}
    end
    
    def are_not_empty?
      instances_for_different_color.any? {|kw| !instance_variable_get(kw).empty?}
    end 
    
    def str(word, i, ind = 0) 
      if are_not_empty?
        instances_for_different_color.each {|instance| send("#{instance.sub("@", "")}", word, i, ind) unless instance_variable_get(instance).empty?}
      else
        @reference_word.clear if !word_to_indent?(word) && word !~ /\s+/
        @keywords[word].call(word, i, ind) 
      end 
      include_word_for_indentation_and_optional_do(word, i, ind) 
    end 
    
    def include_word_for_indentation_and_optional_do(word, i, ind)
      @list_end_words << word if words_related_to_end?(word, i, ind) && empty_list?
      @optional_do << word if optional_do?(word, i, ind) 
    end

    def word_to_indent?(word)
      %w{if unless until for def class module case while begin}.any? {|kw| kw == word}
    end
    
    def optional_do?(word, i, ind)
      %w{if while until}.any? {|kw| kw == word && i == 0 && ind == 0}
    end
    
   
    def end_method(word, i, ind) 
      if @list_end_words.empty? || ind != 0 
        add(word)
      else
        @keywords[@list_end_words.last].call(word, i, ind)
        @list_end_words.pop 
      end 
    end 
    
    def new_line 
      highlight 
      add("\n") 
    end 
    
    def convert 
      @auto_highlight = false 
      @a = @entry.value 
      @a.gsub!(/^\d*\)/, "") 
      @entry.delete(1.0, 'end') 
      add(@a) 
    end 
    
    def analyze(word, i) 
      words = word.split(/(\\[\'\"\/\#{\\]|%[wWqQr]*[|\=\^!\"\$-]|\$[\']*|\^|\=begin|\=end|\||\<\<\-*["\']*\w+["\']*|\.|!|\?[\"\'\/]*|%[wWqQr]*[\{\[\(]|\/|{|}|"|\'|\+|\-|\=|\~|\*|\\|\<|\>|\[|\]|\#{|\#|\d|\:\:|\)|\;|\,|&&|\()/) 
      words.each_with_index do |w, ind| 
        str(w, i, ind)  
      end 
    end 
    
    def punctuation?(word) 
      view = word.scan(/\\[\'\"\/\#{\\]|%[wWqQr]*[|\=\^!\"\$-]|\$[\']*|\^|\=begin|\=end|\||\<\<\-*["\']*\w+["\']*|\.|!|\?[\"\'\/]*|%[wWqQr]*[\{\[\(]|\/|\(|\)|{|}|"|\'|\[|\]|\+|\*|\\|\=|\~|\-|\<|\>|\d|\:\:|\#{|\#|\;|\,|&&/)
      return true if view.length != 0  
    end 
    
    def words_related_to_end?(word, i, ind) 
      (((i == 0 && ind == 0) || !@reference_word.empty?)  && (word_to_indent?(word))) || (word == "do" && @optional_do.empty?) 
    end 
    
    def other_word(word, i)
      if punctuation?(word) 
        analyze(word, i) 
      else 
        str(word, i)  
      end 
    end 
    
    def empty_list? 
      instances_for_different_color.all? {|inst| instance_variable_get(inst).empty?}
    end 
    
    def indent
      %w{module class def if case while do begin unless until for}.each {|n| add("  " * @list_end_words.count(n))} 
    end
    
    def empty_array
      (%w{@list_end_words @def_name @reference_word @interpolation @optional_do @start_multiline_str} +
      instances_for_different_color).each {|inst| instance_variable_set(inst, [])}
    end
    
    def clear_array
      [@comments, @def_name, @div, @reference_word, @optional_do].each {|n| n.clear}
      @multiline_str << @start_multiline_str[0] unless @start_multiline_str.empty?
    end
    
    def set_number(i)
      num = "%03d" % i if @num_lin >= 100 
      num = "%02d" % i if @num_lin <= 99 
      add("#{num})", 'grey') 
      add("  ") 
    end
    
    def start_indentation_and_number(i)
      clear_array
      set_number(i)
      indent 
    end 
    
    def add_text(text_for_indentation_and_syntax_highlight)
      @text = text_for_indentation_and_syntax_highlight
      @num_lin = @text.split(/\n/).length 
      total_delete 
      @text.gsub(/^\d*\)/, "").each_line.with_index(1) do |line, i| 
        add("\n") unless i == 1 
        start_indentation_and_number(i)
        line.sub(/^\s+/, "").gsub(/\n/, "").split(/(\s+)/).each_with_index do |word, i|
          other_word(word, i)
        end 
      end
    end
    
    def highlight 
      if @auto_highlight 
        empty_array
        add_text(@entry.value)
      else
        add(' ')  
      end 
    end 
    
  end    
