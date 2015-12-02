# coding: utf-8
# http://AdventOfCode.com/
# Day 2
require_relative 'input'

input = Input.for_day(2)

# star 1
total_paper = 0
# star 2
total_ribbon = 0

input.each_line do |line|
  h,d,w = line.split('x').map(&:to_i).sort
  paper = 3*h*d + 2*d*w + 2*w*h
  total_paper += paper
  ribbon = 2*h + 2*d + h*d*w
  total_ribbon += ribbon
end

puts "Total paper  %d ft²"%total_paper
puts "Total ribbon %d ft"%total_ribbon
