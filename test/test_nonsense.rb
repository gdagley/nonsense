require File.dirname(__FILE__) + "/../lib/nonsense"
require 'rubygems'
require 'test/spec'
require 'mocha'
require 'time'

describe 'nonsense' do
  attr_accessor :nonsense
  
  before do
    @nonsense = Nonsense.new(:template)
  end
  
  it "should parse the template to get the result" do
    nonsense.expects(:parse_template).with(:template)
    nonsense.result
  end
  
  it "should parse a template" do
    nonsense.expects(:parse).with('template')
    nonsense.parse_template "{template}"
  end
  
  it "should parse a number range" do
    tag = "#2-5"
    nonsense.expects(:number_in_range).with(2, 5)
    
    nonsense.parse tag
  end
  
  it "should pick a random number in a range" do
    nonsense.expects(:rand).with(3).returns(2)
    number = nonsense.number_in_range(2, 5)
    
    number.should == 4
  end
  
  it "should parse a time" do
    tag = "@%A"
    nonsense.expects(:format_current_time).with('%A')
    
    nonsense.parse tag    
  end
  
  it "formats current time" do
    time = Time.parse('2008-05-01 19:00')
    Time.expects(:now).returns(time)
    
    nonsense.format_current_time('%Y').should == "2008"
  end
  
  it "should parse a time and range" do
    tag = "@%A|0|86400"
    nonsense.expects(:format_current_time).with('%A', 0, 86400)
    
    nonsense.parse tag    
  end
  
  it "formats current time less a random value in range" do
    time = Time.parse('2008-05-01 19:00')
    Time.expects(:now).returns(time)
    nonsense.expects(:number_in_range).with(0, 86400).returns(0)
    
    nonsense.format_current_time('%A', 0, 86400).should == "Thursday"
  end
  
  it "should parse a time and store in key" do
    tag = "@%A|$key|86400"
    nonsense.expects(:format_assigned_time).with('%A', 'key', '86400')
    
    nonsense.parse tag    
  end
    
  it "stores time for later use" do
    time = Time.parse('2008-05-01 19:00')
    Time.expects(:now).returns(time)
    nonsense.expects(:rand).returns(0)
    
    nonsense.format_assigned_time('%A', 'key', 0)
    nonsense.state['key'].should == time
  end

  it "retrieves time from earlier" do
    time = Time.parse('2008-05-01 19:00')
    nonsense.state['key'] = time
    nonsense.expects(:rand).returns(0)
    
    nonsense.format_assigned_time('%A', 'key', 0)
    nonsense.state['key'].should == time
  end
    
  it "should parse list of values" do
    tag = "[list of values"
    nonsense.expects(:choose_from_list).with('list of values')
    
    nonsense.parse tag    
  end
  
  it "returns a random value from list of multiple values" do
    nonsense.expects(:rand).returns(1)
    nonsense.choose_from_list("item 1|item 2|item 3").should == "item 2"
  end
  
  it "randomly returns value when list has one item" do
    nonsense.expects(:rand).returns(0)
    nonsense.choose_from_list("item 1").should == "item 1"
  end
  
  it "randomly returns nothing when list has one item" do
    nonsense.expects(:rand).returns(1)
    nonsense.choose_from_list("item 1").should == ''
  end
  
  it "should parse special characters" do
    tag = '\n'
    nonsense.expects(:embed_character).with('n')
    
    nonsense.parse tag
  end
  
  it "returns newline from embeded n" do
    nonsense.embed_character('n').should == "\n"
  end
  
  it "returns nothing from embedded 0" do
    nonsense.embed_character('0').should == ''
  end
  
  it "returns left bracket from embedded L" do
    nonsense.embed_character('L').should == '{'
  end

  it "returns right bracket from embedded R" do
    nonsense.embed_character('R').should == '}'
  end
  
  it "returns ASCII from embedded int" do
    nonsense.embed_character('65').should == 'A'
  end

  it "returns nothing for unknown char" do
    nonsense.embed_character('z').should == ''
  end
  
  it "assigns a command for later use" do
    tag = "key:=command"
    nonsense.expects(:assign_command).with('key', 'command')
    nonsense.parse tag
  end
  
  it "returns nothing when assigning a command" do
    nonsense.assign_command('key', 'command').should == ''
  end
  
  it "parses the command for later use" do
    nonsense.expects(:parse).returns('result')
    nonsense.assign_command('key', 'command')
    nonsense.state['key'].should == 'result'
  end
  
  it "assigns a command for later use" do
    tag = "key=literal"
    nonsense.expects(:assign_literal).with('key', 'literal')
    nonsense.parse tag
  end
  
  it "returns nothing when assigning a literal" do
    nonsense.assign_literal('key', 'literal').should == ''
  end
  
  it "stores the command for later use" do
    nonsense.assign_literal('key', 'literal')
    nonsense.state['key'].should == 'literal'
  end
  
  it "retrieves previously assigned earlier" do
    tag = "$key"
    nonsense.expects(:retrieve_assigned).with('key')
    nonsense.parse tag
  end
  
  it "retrieves the assigned value by the key" do
    nonsense.state['key'] = 'value'
    nonsense.retrieve_assigned('key').should == 'value'    
  end
  
  it "retrieves value multiple times" do
    tag = 'tag#1-4'
    nonsense.expects(:retrieve_multiple).with('tag', 1, 4)
    nonsense.parse tag
  end
  
  it "should retrieve parsed value of tag a random number of times" do
    nonsense.expects(:number_in_range).with(1, 4).returns(2)
    nonsense.expects(:parse).times(2)
    nonsense.retrieve_multiple('tag', 1, 4)
  end

  it "should retrieve parsed value of tag a random number of times" do
    nonsense.expects(:number_in_range).with(1, 4).returns(2)
    nonsense.stubs(:parse).returns('result')
    nonsense.retrieve_multiple('tag', 1, 4).should == "result result"
  end
  
  it "retrieves previously assigned earlier" do
    tag = "tag"
    nonsense.expects(:retrieve_data).with('tag')
    nonsense.parse tag
  end
  
  it "returns nothing when retrieving data with no key" do
    nonsense.retrieve_data(nil).should == ''
  end
  
  it "returns nothing when there is not data that matches key" do
    nonsense.retrieve_data('nothing').should == ''
  end
  
  it "returns random choices that matches key" do
    nonsense.data['key'] = ['choice 1', 'choice 2']
    nonsense.expects(:rand).returns(1)
    nonsense.retrieve_data('key').should == 'choice 2'
  end
  
  it "upcases the result when key is all caps" do
    nonsense.adjust_case('result', 'KEY').should == 'RESULT'
  end

  it "downcases the result when key is all lowercase" do
    nonsense.adjust_case('Result', 'key').should == 'result'
  end
  
  it "capitalizes the result when key starts with ^" do
    nonsense.adjust_case('result', '^Key').should == 'Result'
  end
  
  it "returns the result when the case is not recognize" do
    nonsense.adjust_case('RESult', 'kEy').should == 'RESult'    
  end
  
end