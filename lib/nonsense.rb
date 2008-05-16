require 'yaml'

class Nonsense
  VERSION = '1.0.0'
  
  attr_accessor :template, :data, :state, :debug
  
  module Data
    DEFAULT = YAML.load_file(File.dirname(__FILE__) + '/default.yml')
  end
    
  def initialize(template, data = {})
    @template = template
    @data     = Data::DEFAULT.merge(data)
    @state    = {}
  end
  
  def result
    parse_template self.template
  end
  
  def parse_template(t)
    return '' unless t
    t = t.dup
    copy = t.gsub!(/\{[^}]+\}/) { |tag| parse tag[1..-2] }
    copy ? copy : t
  end
  
  def parse tag
    return '' unless tag
    parse_case = nil
    parsed = case tag
    when /^#(\d+)-(\d+)$/            then number_in_range($1.to_i, $2.to_i).to_s
    when /^\@([^|]+)$/               then format_current_time($1)
    when /^\@(.*?)\|\$(\w+)\|(\d+)$/ then format_assigned_time($1, $2, $3)
    when /^\@(.*?)\|(\d+)\|(\d+)$/   then format_current_time($1, $2.to_i, $3.to_i)
    when /^\[(.*)$/                  then choose_from_list($1)
    when /^\\(.*)$/                  then embed_character($1)
    when /^(.*?):=(.*)$/             then assign_command($1, $2)
    when /^(.*?)=(.*)$/              then assign_literal($1, $2)
    when /^[\$<](.*)$/
      parse_case = $1
      retrieve_assigned($1)
    when /^(.*?)#(\d+)-(\d+)$/
      parse_case = $1
      retrieve_multiple($1, $2.to_i, $3.to_i)
    else
      parse_case = tag
      retrieve_data tag.gsub(/\W/, '')
    end
    
    parsed = parse_template(parsed)

    parsed = adjust_case parsed, parse_case
  end
  
  def number_in_range(low, high)
    rand(high - low).to_i + low
  end
  
  def format_current_time(format, low = nil, high = nil)
    diff = (low && high) ? number_in_range(low, high) : 0
    (Time.now - diff).strftime format
  end
  
  def format_assigned_time(format, key, high)
    existing_time = state[key.downcase]
    elapsed = rand(high)
    time = if existing_time
      existing_time - elapsed
    else
      Time.now - elapsed
    end
    state[key] = time
    time.strftime format
  end
  
  def choose_from_list(list)
    items = list.split('|')
    choice = if items.size > 1
      items[rand(items.size)]       # pick one of the elements
    else
      rand(2) == 0 ? items[0] : ''  # pick it or pick nothing
    end
  end
  
  def embed_character(character)
    case character
    when 'n'    then "\n"               # newline
    when '0'    then ''                 # null
    when 'L'    then '{'                # left bracket
    when 'R'    then '}'                # right bracket
    when /^\d+/ then character.to_i.chr # ASCII code in decimal
    else ''                             # not in list
    end
  end
  
  def assign_command(key, command)
    state[key.downcase] = parse(command)
    ''
  end
  
  def assign_literal(key, value)
    state[key.downcase] = value
    ''
  end
  
  def retrieve_assigned(key)
    value = state[key.downcase]
    value ? value : parse(key)
  end
  
  def retrieve_multiple(key, low, high)
    n = number_in_range(low, high)
    return '' if n == 0
    (1..n).collect { |i| parse(key) }.join(" ")
  end
  
  def retrieve_data(key)
    return '' unless key
    choices = data[key.downcase]
    choices ? choices[rand(choices.size)] : ''
  end
  
  def adjust_case parsed, parse_case
    case parse_case
    when /^[A-Z0-9]+$/    then parsed.upcase
    when /^[a-z0-9]+$/    then parsed.downcase
    when /^\^/            then parsed.capitalize
    else                       parsed
    end
  end
end