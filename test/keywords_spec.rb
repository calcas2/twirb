require './test/test_helper'
require 'manipulation'
require 'keywords'

class UnitKeywords
  attr_accessor :entry, :keywords, :comments_multiline, :literal_array, :div, :def_name, :regex
  include Keywords
  include Manipulation
  def initialize
    @mod = []
    @div = []
    @interpolation = []
  end
  def add(word, color = "no color")
    @entry.send("<<", "#{word}[#{color}]") 
  end
  def delete(num1, num2)
    @entry.reverse!.sub!(/\s\s/, "").reverse!
  end
  def total_delete
    @entry = ""
  end
end

describe Manipulation do
  before :each do
    @instance = UnitKeywords.new
    @instance.entry = ""
    @instance.setup
    @instance.empty_array
  end

  it 'must have 94 keywords'  do
    @instance.keywords.keys.length.must_equal 94
  end

  it 'test_color_comments_multiline_and_array_related' do
    @instance.keywords["=begin"].call("=begin", 0, 0)
    @instance.entry.must_equal  "=begin[grey90]"
    @instance.comments_multiline.must_equal  ["=begin"]
    @instance.total_delete
    @instance.keywords["=end"].call("=end", 0, 0)
    @instance.entry.must_equal "=end[grey90]"
    @instance.comments_multiline.must_equal [] 
  end

  def test_color_literal_string_and_array_
    @instance.keywords["%Q{"].call("%Q{", 0, 0)
    @instance.entry.must_equal "%Q{[violet]"
    @instance.literal_array.must_equal ["%Q{"]
    @instance.total_delete
    @instance.keywords["}"].call("}", 0, 0)
    @instance.entry.must_equal "}[violet]"
    @instance.literal_array.must_equal []
    @instance.total_delete
    @instance.keywords["%r{"].call("%r{", 0, 0)
    @instance.entry.must_equal "%r{[violet]"
    @instance.literal_array.must_equal ["%r{"]
    @instance.total_delete
    @instance.keywords["}"].call("}", 0, 0)
    @instance.entry.must_equal "}[violet]"
    @instance.literal_array.must_equal []
    @instance.total_delete
    @instance.keywords["}"].call("}", 0, 0)
    @instance.entry.must_equal "}[red]"
  end

  def test_color_constant
    @instance.keywords["Test"].call("Test", 0, 0)
    @instance.entry.must_equal "Test[green]"
    @instance.div.must_equal ["Test"]
    @instance.total_delete
    @instance.keywords["Constant"].call("Constant", 0, 0)
    @instance.entry.must_equal "Constant[green]"
  end

  def test_color_symbol_and_array_related
    @instance.keywords[":hello"].call(":hello", 0, 0)
    @instance.entry.must_equal ":hello[yellow]"
    @instance.div.must_equal []
    @instance.total_delete
    @instance.keywords[":test"].call(":test", 0, 0)
    @instance.entry.must_equal ":test[yellow]"
  end

  def test_color_def_method_and_method_name
    @instance.keywords["def"].call("def", 0, 0)
    @instance.entry.must_equal "def[blue]"
    @instance.def_name.must_equal ["def"]
    @instance.add(" ")
    @instance.keywords["method_name"].call("method_name", 0, 0)
    @instance.entry.must_equal "def[blue] [no color]method_name[red]"
    @instance.def_name.must_equal []
  end

  def test_color_class_and_module
    @instance.keywords["class"].call("class", 0, 0)
    @instance.entry.must_equal "class[blue]"
    @instance.add(" ")
    @instance.keywords["Class_name"].call("Class_name", 0, 0)
    @instance.entry .must_equal "class[blue] [no color]Class_name[green]"
    @instance.total_delete
    @instance.keywords["module"].call("module", 0, 0)
    @instance.entry.must_equal "module[blue]"
  end

  def test_color_mathematic_division_and_not_regex
    @instance.keywords["3"].call("3", 0, 0)
    @instance.entry.must_equal "3[brown]"
    @instance.div.must_equal ["3"]
    @instance.add(" ")
    @instance.keywords["/"].call("/", 0, 0)
    @instance.entry.must_equal "3[brown] [no color]/[violet]"
    @instance.div.must_equal ["3"]
  end
end
