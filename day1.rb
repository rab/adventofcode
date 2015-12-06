# http://AdventOfCode.com/
# Day 1
# --- Day 1: Not Quite Lisp ---
#
# Santa was hoping for a white Christmas, but his weather machine's "snow" function is powered by stars,
# and he's fresh out! To save Christmas, he needs you to collect fifty stars by December 25th.
#
# Collect stars by helping Santa solve puzzles. Two puzzles will be made available on each day in
# the advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle
# grants one star. Good luck!
#
# Here's an easy puzzle to warm you up.
#
# Santa is trying to deliver presents in a large apartment building, but he can't find the right
# floor - the directions he got are a little confusing. He starts on the ground floor (floor 0)
# and then follows the instructions one character at a time.
#
# An opening parenthesis, (, means he should go up one floor, and a closing parenthesis, ), means
# he should go down one floor.
#
# The apartment building is very tall, and the basement is very deep; he will never find the top
# or bottom floors.
#
# For example:
#
# (()) and ()() both result in floor 0.
# ((( and (()(()( both result in floor 3.
# ))((((( also results in floor 3.
# ()) and ))( both result in floor -1 (the first basement level).
# ))) and )())()) both result in floor -3.
# To what floor do the instructions take Santa?
#
# Your puzzle answer was 232.

# --- Part Two ---
#
# Now, given the same instructions, find the position of the first character that causes him to
# enter the basement (floor -1). The first character in the instructions has position 1, the
# second character has position 2, and so on.
#
# For example:
#
# ) causes him to enter the basement at character position 1.
# ()()) causes him to enter the basement at character position 5.
# What is the position of the character that causes Santa to first enter the basement?
#
# Your puzzle answer was 1783.

require_relative 'input'

floors = Input.for_day(1)

UP = '('
DOWN = ')'

ups = floors.count(UP)
downs = floors.count(DOWN)

puts "Ends on %d"%[ups - downs]

floor = 0
floors.each_char.with_index do |move,i|
  case move
  when UP   ; floor += 1
  when DOWN ; floor -= 1
  else
    puts "crap! what is #{move.inspect}"
    exit
  end
  if floor == -1
    puts "Basment first on position %d"%[i+1]
    break
  end
end
