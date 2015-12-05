# coding: utf-8
# http://AdventOfCode.com/
# --- Day 4: The Ideal Stocking Stuffer ---

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
