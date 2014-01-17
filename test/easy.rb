#!/usr/bin/env rvm 2.1.0 do ruby
$:.push('../lib')
require 'byggvir/simple'

def easy(pets: ,humans: [:mommy, :daddy], gifts: 0, money: 0.0)
  puts "Pets: #{pets}, Humans #{humans}, Gifts #{gifts}, Money: #{money}"
end
