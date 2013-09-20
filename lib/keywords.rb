  module Keywords 
    attr_reader :keywords 
    def setup 
      @keywords = Hash.new do |h, k|
        m = /^(?<constant>[A-Z])|(?<symbol>:)|(?<inst_var>@)|(?<double_arr><<)|(?<percent>%)|(?<semi_col>;)|(?<dot_com>\.|\,)|/.match(k)
        if m[0] != ""
          h[k] = lambda do |k, i, ind|
            m.names.each {|name| send(name, k) if m[name] != nil}
          end
        else
          h[k] = lambda do |n, i, ind| 
            if !@def_name.empty? 
              @def_name.clear 
              add("#{n}", 'red') 
            else 
              @div << n 
              add("#{n}")  
            end 
          end 
        end 
      end
      
      @keywords[" "] = lambda do |n, i, ind| 
        add("#{n}")
      end
      
      %w{self true false nil return super}.each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          add("#{n}", 'DarkOrange') 
        end 
      end 
      
      %w{class def module alias}.each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          @def_name << n if w == "def"
          add("#{n}", 'blue') 
        end 
      end 
      
      (0..9).to_a.map {|n| n.to_s}.each do |w| 
        @keywords[w] = lambda do |n, i, ind|   
          @div << n 
          add("#{n}", 'brown') 
        end 
      end 
      
      ["if", 
      "while", 
      "do", 
      "{", "}", 
      "case", 
      "require", "include", "require_relative", 
      "lambda", "proc", "yield", 
      "begin", 
      "unless", 
      "then", "and", "or", "not", "|", "&&", 
      "until", "for", "in", 
      "retry", "redo", 
      "next", "break", 
      "attr_accessor", "attr_reader", "attr_writer"].each do |w| 
        if w == "}" 
          @keywords[w] = lambda do |n, i, ind| 
            @div.clear 
            if !@literal_array.empty? 
              @literal_array.clear 
              add("#{n}", 'violet')  
            else 
              add("#{n}", 'red') 
            end 
          end 
        else 
          @keywords[w] = lambda do |n, i, ind| 
            @div.clear #if w == "{"
            add("#{n}", 'red') {@reference_word << n if n == "require"}
          end 
        end 
      end 
      
      ["elsif", "rescue", "else", "when"].each do |w| 
        @keywords[w] = lambda do |n, i, ind|
          @div.clear 
          num1 = 4 if @num_lin <= 99 
          num1 = 5 if @num_lin >= 100 
          num2 = num1 + 2 
          if !@list_end_words.empty? && i == 0 #@mod.empty? 
            delete(num1, num2)
          end 
          add("#{n}", 'red') 
        end 
      end 
      
      
      @keywords["end"] = lambda do |n, i, ind| 
        num1 = 4 if @num_lin <= 99 
        num1 = 5 if @num_lin >= 100 
        num2 = num1 + 2 
        if !@list_end_words.empty? && i == 0 && ind == 0
          delete(num1, num2)
        end 
        end_method(n, i, ind) 
      end 
      
      @keywords["\\"] = lambda do |n, i, ind| 
        @div.clear 
        add("#{n}", 'violet') 
      end 
      
      ["%q{", "%Q{", "%r{", "%{", "%w{", "%W{"].each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          @literal_array << n 
          add("#{n}", 'violet') 
        end 
      end 
      
      ["%q[", "%Q[", "%r[", "%[", "%w[", "%W["].each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          @literal_array_square << n 
          add("#{n}", 'violet') 
        end 
      end 
      
      ["%q(", "%Q(", "%r(", "%(", "%w(", "%W("].each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          @literal_array_parenthesis << n 
          add("#{n}", 'violet') 
        end 
      end 
      
      
      @keywords["=begin"] = lambda do |n, i, ind| 
        @comments_multiline << n 
        add("#{n}", 'grey90') 
      end 
      
      @keywords["=end"] = lambda do |n, i, ind| 
        @comments_multiline.clear 
        add("#{n}", 'grey90') 
      end 
     
      @keywords["#"] = lambda do |n, i, ind| 
        @comments << n 
        add("#{n}", 'grey90') 
      end 
      
      @keywords['"'] = lambda do |n, i, ind| 
        @double_quote << n 
        add("#{n}", 'violet') 
      end 
      
      @keywords["'"] = lambda do |n, i, ind| 
        @single_quote << n 
        add("#{n}", 'violet') 
      end 
      
      @keywords["/"] = lambda do |n, i, ind| 
        @regex << n if @div.length == 1 || @div.empty?
        add("#{n}", 'violet') 
      end 
      
      %w{+ - * = < > ! ~ ?}.each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          @div.clear
          @reference_word << n if n == "=" || n == "<" 
          add("#{n}", 'red') 
        end 
      end 
      
      @keywords["]"] = lambda do |n, i, ind| 
        @div << n 
        if !@literal_array_square.empty? 
          @literal_array_square.clear 
          add("#{n}", 'violet') 
        else 
          add("#{n}") 
        end 
      end 

      @keywords[")"] = lambda do |n, i, ind| 
        if !@literal_array_parenthesis.empty?
          @literal_array_parenthesis.pop
          add("#{n}", 'violet')
        else  
          add("#{n}", 'not_imp') 
        end
      end  
      
      %w{ ( [ }.each do |w| 
        @keywords[w] = lambda do |n, i, ind| 
          @div.clear
          @reference_word << n if n == "("
          add("#{n}") 
          end 
        end 
      end  
    
    
    %w{constant symbol inst_var double_arr percent semi_col dot_com}.each do |m|
      define_method(m) do |k|
        @div << k if m == "constant" || m == "inst_var"
        @div.clear if m == "symbol" || m == "double_arr" || m == "semi_col" || m == "dot_com" || m == "percent"
        #@multiline_str << k if m == "double_arr"
        @start_multiline_str << k if m == "double_arr" and !("0".."9").include?(k[2])
        @delimiter_multi_str << k if m == "percent" and %w{| ! " $ = - ^}.include?(k[k.length - 1])
        #@mod << k if m == "semi_col"
        @def_name.clear if m == "semi_col"
        @reference_word << k if m == "semi_col"
        add(k, 'green') if m == "constant"
        add(k, 'yellow') if m == "symbol"
        add(k, 'brown') if m == "inst_var"
        add(k, 'violet') if m == "double_arr" || m == "percent"
        add(k) if m == "semi_col" || m == "dot_com"
      end
    end 
  end 
