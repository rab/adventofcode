# coding: utf-8
# http://AdventOfCode.com/
# --- Day 3: Perfectly Spherical Houses in a Vacuum ---
#
# Santa is delivering presents to an infinite two-dimensional grid of houses.
#
# He begins by delivering a present to the house at his starting location, and then an elf at the
# North Pole calls him via radio and tells him where to move next. Moves are always exactly one
# house to the north (^), south (v), east (>), or west (<). After each move, he delivers another
# present to the house at his new location.
#
# However, the elf back at the north pole has had a little too much eggnog, and so his directions
# are a little off, and Santa ends up visiting some houses more than once. How many houses receive
# at least one present?
#
# For example:
#
# > delivers presents to 2 houses: one at the starting location, and one to the east.
#
# ^>v< delivers presents to 4 houses in a square, including twice to the house at his
# starting/ending location.
#
# ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.
#
# Your puzzle answer was 2081.
#
# --- Part Two ---
#
# The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to
# deliver presents with him.
#
# Santa and Robo-Santa start at the same location (delivering two presents to the same starting
# house), then take turns moving based on instructions from the elf, who is eggnoggedly reading
# from the same script as the previous year.
#
# This year, how many houses receive at least one present?
#
# For example:
#
# ^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
#
# ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
#
# ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa
# going the other.
#
# Your puzzle answer was 2341.

require_relative 'input'

input = Input.for_day(3)

class Location
  DIRECTION = { '^' => :north, '<' => :west, '>' => :east, 'v' => :south }
  attr_reader :x, :y
  def initialize(where)
    @x, @y = *where
  end
  def move(direction)
    send(DIRECTION[direction])
  end
  private
  def north ; @y += 1 ; end
  def west  ; @x -= 1 ; end
  def east  ; @x += 1 ; end
  def south ; @y -= 1 ; end
end

class Deliveries
  def initialize
    @deliveries = Hash.new {|hx,x| hx[x] = Hash.new(0) }
  end
  def deliver_to(where)
    @deliveries[where.x][where.y] += 1
  end
  def houses_visited
    houses = 0
    @deliveries.each {|x,ys| houses += ys.size}
    houses
  end
end


location = Location.new [0,0]

single_deliveries = Deliveries.new
single_deliveries.deliver_to location

santa_location = Location.new [0,0]
robot_location = Location.new [0,0]

shared_deliveries = Deliveries.new
shared_deliveries.deliver_to santa_location
shared_deliveries.deliver_to robot_location
queue = [ santa_location, robot_location ] # Santa delivers first

input.each_char do |move|
  location.move move
  queue[0].move move
  single_deliveries.deliver_to location
  shared_deliveries.deliver_to queue[0]
  queue.push queue.shift        # "Back of the line, you!"
end


# star 1
visited = single_deliveries.houses_visited
puts "Alone:    Delivered presents to %d houses"%[visited]

# star 2
shared = shared_deliveries.houses_visited
puts "Together: Delivered presents to %d houses"%[shared]
