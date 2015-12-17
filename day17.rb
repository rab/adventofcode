# coding: utf-8
# http://AdventOfCode.com/
# --- Day 17: No Such Thing as Too Much ---
#
# The elves bought too much eggnog again - 150 liters this time. To fit it all into your
# refrigerator, you'll need to move it into smaller containers. You take an inventory of the
# capacities of the available containers.
#
# For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to
# store 25 liters, there are four ways to do it:
#
# 15 and 10
# 20 and 5 (the first 5)
# 20 and 5 (the second 5)
# 15, 5, and 5
#
# Filling all containers entirely, how many different combinations of containers can exactly fit
# all 150 liters of eggnog?

target = 150

# --- Part Two ---
#
# While playing with all the containers in the kitchen, another load of eggnog arrives! The
# shipping and receiving department is requesting as many containers as you can spare.
#
# Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many
# different ways can you fill that number of containers and still hold exactly 150 litres?
#
# In the example above, the minimum number of containers was two. There were three ways to use
# that many containers, and so the answer there would be 3.

require_relative 'input'
day = /day(\d+)\.rb/.match(__FILE__)[1].to_i
# target = 25
# input = <<-EOF
# 20
# 15
# 10
# 5
# 5
# EOF
input = Input.for_day(day)

containers = input.each_line.map {|line| line.chomp.to_i }
puts containers.inspect
require 'set'

matches = Array.new # elements are sorted arrays of integers that sum to target

(1..containers.size).each do |i|
  # puts "i: #{i}"
  containers.combination(i) do |comb|
    # puts "comb: #{comb.inspect}"
    if comb.reduce(:+) == target
      matches << comb.sort
    end
  end
end

puts "#{matches.size} ways to store #{target} liters"

fewest = matches.map(&:size).min
puts "#{matches.count{|m|m.size == fewest}} ways to store #{target} liters using only #{fewest} containers"
