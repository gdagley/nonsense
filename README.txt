= nonsense

== DESCRIPTION:

port of http://nonsense.sourceforge.net/

Taken from Nonsense website:  Nonsense generates random (and sometimes humorous) 
text from datafiles and templates using a very simple, recursive grammar. It's 
like having a million monkeys sitting in front of a million typewriters, without 
having to feed or clean up after them.

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

  require 'lib/nonsense'

  # include extra data if you need it
  data = {'fruit' => ['apple', 'orange', 'banana'] }

  something = Nonsense.new "{FullName} from {USSTate} likes {fruit}", data

  puts something.result

  # or keep everything in external files
  data = YAML.load_file('data.yml')
  something = open('some.template') { |f| Nonsense.new f.read, data }

  puts something.result

== REQUIREMENTS:

* none

== INSTALL:

* sudo gem install nonsense

source is hosted at https://github.com/gdagley/nonsense

== LICENSE:

GNU General Public License 2.0 (same as original nonsense)

Copyright (c) 2008 Geoffrey Dagley

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
