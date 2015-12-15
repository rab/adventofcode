# coding: utf-8
# http://AdventOfCode.com/
# --- Day 12: JSAbacusFramework.io ---
#
# Santa's Accounting-Elves need help balancing the books after a recent order. Unfortunately,
# their accounting software uses a peculiar storage format. That's where you come in.
#
# They have a JSON document which contains a variety of things: arrays ([1,2,3]),
# objects ({"a":1, "b":2}), numbers, and strings. Your first job is to simply find
# all of the numbers throughout the document and add them together.
#
# For example:
#
# [1,2,3] and {"a":2,"b":4} both have a sum of 6.
# [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
# {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
# [] and {} both have a sum of 0.
# You will not encounter any strings containing numbers.
#
# What is the sum of all numbers in the document?

require_relative 'input'
day = /day(\d+)\.rb/.match(__FILE__)[1].to_i
inputs = {
  "[1,2,3]" => 6,
  '{"a":2,"b":4}' => 6,
  '[[[3]]]' => 3,
  '{"a":{"b":4},"c":-1}' => 3,
  '{"a":[-1,1]}' => 0,
  '[-1,{"a":1}]' => 0,
  '[]' => 0,
  '{}' => 0,
}
input = Input.for_day(day)

require 'json'
def numbers_sum(object, ignoring=nil)
  case object
  when Numeric
    object
  when Array
    object.map {|e| numbers_sum(e, ignoring) }.reduce(0, &:+)
  when Hash
    if ignoring && object.values.include?(ignoring)
      0
    else
      object.values.map {|e| numbers_sum(e, ignoring) }.reduce(0, &:+)
    end
  when String
    object.to_i
  when nil
    0
  else
    0
  end
end

# inputs.each do |input, expected|
# print "#{input} "
  obj = JSON.parse(input)
  actual = numbers_sum(obj)
  print "has a sum of #{actual}"
  # if actual == expected
  #   puts " just as expected"
  # else
  #   puts ", but expected #{expected}"
  # end
# end
  puts
  
# --- Part Two ---
#
# Uh oh - the Accounting-Elves have realized that they double-counted everything red.
#
# Ignore any object (and all of its children) which has any property with the value "red". Do this
# only for objects ({...}), not arrays ([...]).
#
# [1,2,3] still has a sum of 6.
# [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
# {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
# [1,"red",5] has a sum of 6, because "red" in an array has no effect.

inputs = {
  '[1,2,3]' => 6,
  '[1,{"c":"red","b":2},3]' => 4,
  '{"d":"red","e":[1,2,3,4],"f":5}' => 0,
  '[1,"red",5]' => 6,
}

# inputs.each do |input, expected|
#   print "#{input} "
  obj = JSON.parse(input)
  actual = numbers_sum(obj, "red")
  print "has a sum of #{actual}"
#   if actual == expected
#     puts " just as expected"
#   else
#     puts ", but expected #{expected}"
#   end
# end
puts

