require './test/test_helper'
require 'keywords'
require 'manipulation'

class UnitManipulation
  attr_accessor :entry, :auto_highlight, :keywords, :comments_multiline, :reference_word
  include Keywords
  include Manipulation
  def initialize
    @div = []
    @interpolation = []
  end
  def add(word, color = "no color")
    @entry.send("<<", word) 
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
    @instance = UnitManipulation.new
    @instance.entry = ""
    @instance.setup
    @instance.empty_array
  end

  it 'must recognize punctuation' do
    @instance.punctuation?("%r/hello/").must_equal true
    @instance.punctuation?('/\\/').must_equal true
    @instance.punctuation?('3+3=6').must_equal true
    @instance.punctuation?("class").must_equal nil
    @instance.punctuation?("if").must_equal nil
  end

  def test_analyze
    assert_equal ["Prova", ".", "new"], @instance.analyze("Prova.new", 0)
    assert_equal ["", "\"", "hello", "!", "", "\""], @instance.analyze('"hello!"', 0)
    assert_equal ["", "%q{", "hello", "!", "", "}"], @instance.analyze('%q{hello!}', 0)
    @instance.analyze('"=begin\nThis is a test comment\n\=end"', 0).must_equal ["", "\"", "", "=begin", "", "\\", "nThis is a test comment", "\\", "n", "\\", "", "=end", "", "\""]
    assert_equal ["", "/", "", "/", "", "|", "", "\\/", "", "/"], @instance.analyze("/\/|\\\//", 0)
  end

  def test_array
    assert_equal [], @instance.instance_eval {@regex}
  end

  it 'must add line numbers for the text when added' do
    @instance.add_text("hello world")
    assert_equal "01)  hello world", @instance.entry
    @instance.add_text("line_1\nline_2\nline_3\nline_4")
    @instance.entry.must_equal "01)  line_1\n02)  line_2\n03)  line_3\n04)  line_4"
  end

  def test_indentation
    @instance.add_text("class Test\ndef nome\nif") 
    assert_equal "01)  class Test\n02)    def nome\n03)      if", @instance.entry
    @instance.empty_array
    @instance.add_text("def prova\n'hello world'\nend")
    assert_equal "01)  def prova\n02)    'hello world'\n03)  end", @instance.entry
    @instance.empty_array
    @instance.add_text("class Test\ndef prova\n'hello world'\nend\nend")
    assert_equal "01)  class Test\n02)    def prova\n03)      'hello world'\n04)    end\n05)  end", @instance.entry
    @instance.empty_array
    @instance.add_text(%Q{def greet; "hello world"; end})
    assert_equal %Q{01)  def greet; "hello world"; end}, @instance.entry 
  end

  def test_instances_for_different_color
    assert_equal false, @instance.are_not_empty?
    @instance.instance_eval {@regex} << "/"
    assert @instance.are_not_empty?
  end


  def test_words_related_to_end
    assert @instance.words_related_to_end?("class", 0, 0)
    @instance.reference_word = ["="]
    assert @instance.words_related_to_end?("begin", 3, 1)
    @instance.empty_array
    assert_equal false, @instance.words_related_to_end?("if", 3, 0)
  end
end
