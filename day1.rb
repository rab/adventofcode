# http://AdventOfCode.com/
# Day 1

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
