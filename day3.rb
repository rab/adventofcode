# coding: utf-8
# http://AdventOfCode.com/
# Day 3
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
