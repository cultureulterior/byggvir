#!/usr/bin/env rvm 2.1.0 do ruby
$:.push('../lib')
require 'byggvir'

class Test < Byggvir::Multiple
  doc "Short floo documentation",
  def floo(frac: 3, froc:, duc:["soy","boy"])
    p [frac,froc,duc]
  end

  def florb(duc: )
    p [duc]
  end
end

Test.new
