byggvir
=======

Byggvir is designed to be the simplest possible command line processing for ruby 2.1

Just require byggvir/simple and off you go!

```ruby
require 'byggvir/simple'

def cat_zoo(cats:, dollars: 0.0):
  puts "#{cats}, #{cost}"
end
```
Byggvir/simple is the most convenient option- it will match the function with the same name as your file.  Integers, floats and arrays are automatically made into the most logical type, and you can use the short, one letter argument if there is no duplication.

```bash
cat_zoo -c "Mr Buttons,spot" -d 5.0
cat_zoo -c Mephistopheles,Drunky -d 5
```

Byggvir/multiple will match multiple subfunctions
```bash
pet dog -n 5
pet cat -n 3
```

Just like Thor
```ruby
require 'byggvir'
class Pet < Byggvir::Multiple
  doc "The number of dogs",
  def dog(number:)

  end

  doc "The number of cats",
  def cat(number:)

  end
end
```

Note that it is currently quite easy to expose bug https://bugs.ruby-lang.org/issues/9308 when using the multiple/doc functionality
