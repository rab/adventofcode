# coding: utf-8
# http://AdventOfCode.com/
# --- Day 5: Doesn't He Have Intern-Elves For This? ---
#
# Santa needs help figuring out which strings in his text file are naughty or nice.
#
# A nice string is one with all of the following properties:
#
# It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
# It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
# For example:
#
# ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
# aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
# jchzalrnumimnmhp is naughty because it has no double letter.
# haegwjzuvuyypxyu is naughty because it contains the string xy.
# dvszwmarrgswjxmb is naughty because it contains only one vowel.
# How many strings are nice?


require_relative 'input'

module Santa
  extend self

  # star 1
  VOWELS = 'aeiou'
  DOUBLE_LETTER = /([a-z])\1/
  BAD_COMBOS = [ /ab/, /cd/, /pq/, /xy/ ]

  def check(string)
    if string.count(VOWELS) >= 3 && DOUBLE_LETTER =~ string && BAD_COMBOS.none? {|combo| combo =~ string }
      :nice
    else
      :naughty
    end
  end

  # star 2
  DOUBLE_PAIR = /([a-z]{2}).*\1/
  CLOSE_REPEAT = /([a-z]).\1/

  def check_twice(string)
    if DOUBLE_PAIR =~ string && CLOSE_REPEAT =~ string
      :nice
    else
      :naughty
    end
  end
end

input = Input.for_day(5)

# star 1
samples = { nice: %w[ ugknbfddgicrmopn aaa ],
            naughty: %w[ jchzalrnumimnmhp haegwjzuvuyypxyu dvszwmarrgswjxmb ],
          }

samples.each do |expected, input|
  input.each do |string|
    unless expected == (actual = Santa.check(string))
      puts "#{string} is #{actual}, but should be #{expected}"
      exit
    end
  end
end

counts = { nice: 0,
           naughty: 0,
         }

input.each_line do |string|
  counts[Santa.check(string)] += 1
end

puts "Of the #{counts.values.reduce(:+)} strings,"
counts.each do |type,count|
  puts "%5d are %s"%[count,type]
end

# star 2
# --- Part Two ---

# Realizing the error of his ways, Santa has switched to a better model of determining whether a
# string is naughty or nice. None of the old rules apply, as they are all clearly ridiculous.

# Now, a nice string is one with all of the following properties:

# It contains a pair of any two letters that appears at least twice in the string without
# overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
# It contains at least one letter which repeats with exactly one letter between them, like xyx,
# abcdefeghi (efe), or even aaa.
# For example:

# qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
# xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
# uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
# ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.
# How many strings are nice under these new rules?

samples = { nice: %w[ qjhvhtzxzqqjkmpb xxyxx ],
            naughty: %w[ uurcxstgmygtbstg ieodomkazucvgmuy ],
          }

samples.each do |expected, input|
  input.each do |string|
    unless expected == (actual = Santa.check_twice(string))
      puts "#{string} is #{actual}, but should be #{expected}"
      exit
    end
  end
end

puts "\nWhen checking it again:"
counts = { nice: 0,
           naughty: 0,
         }

input.each_line do |string|
  counts[Santa.check_twice(string)] += 1
end

puts "Of the #{counts.values.reduce(:+)} strings,"
counts.each do |type,count|
  puts "%5d are %s"%[count,type]
end
