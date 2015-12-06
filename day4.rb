# coding: utf-8
# http://AdventOfCode.com/
# --- Day 4: The Ideal Stocking Stuffer ---
#
# Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the
# economically forward-thinking little girls and boys.
#
# To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five
# zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed
# by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no
# leading zeroes: 1, 2, 3, ...) that produces such a hash.
#
# For example:
#
# If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts
# with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
#
# If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting
# with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....
#
# Your puzzle answer was 254575.
#
# --- Part Two ---
#
# Now find one that starts with six zeroes.
#
# Your puzzle answer was 1038736.

require_relative 'input'

input = 'bgvyzdsv' # Input.for_day(4)

require 'digest'

format = "#{input}%d"
re5 = /\A0{5}/
re6 = /\A0{6}/

# star 1
number = 1
until re5 =~ Digest::MD5.hexdigest(format%number)
  number += 1
end
puts "With 5 zeros: number is %d"%number

# star 2
until re6 =~ Digest::MD5.hexdigest(format%number)
  number += 1
end
puts "With 6 zeros: number is %d"%number

# Extra credit
re7 = /\A0{7}/
until re7 =~ Digest::MD5.hexdigest(format%number)
  number += 1
end
puts "With 7 zeros: number is %d"%number
