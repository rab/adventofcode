# coding: utf-8
# http://AdventOfCode.com/
# --- Day 6: Probably a Fire Hazard ---
#
# Because your neighbors keep defeating you in the holiday house decorating contest year after
# year, you've decided to deploy one million lights in a 1000x1000 grid.
#
# Furthermore, because you've been especially nice this year, Santa has mailed you instructions on
# how to display the ideal lighting configuration.
#
# Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are
# at 0,0, 0,999, 999,999, and 999,0. The instructions include whether to turn on, turn off, or
# toggle various inclusive ranges given as coordinate pairs. Each coordinate pair represents
# opposite corners of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore
# refers to 9 lights in a 3x3 square. The lights all start turned off.
#
# To defeat your neighbors this year, all you have to do is set up your lights by doing the
# instructions Santa sent you in order.
#
# For example:
#
# turn on 0,0 through 999,999 would turn on (or leave on) every light.
#
# toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that
# were on, and turning on the ones that were off.
#
# turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
#
# After following the instructions, how many lights are lit?

require_relative 'input'
day = /day(\d+)\.rb/.match(__FILE__)[1].to_i
input = Input.for_day(day)

class BinaryLights
  CMD = /(toggle|(?:turn[_ ]o(?:n|ff))) (\d+),(\d+) through (\d+),(\d+)/

  def initialize(x: 1000, y: 1000)
    @lights = Array.new(x) { Array.new(y) { false } }
  end

  def command(line)
    cmd, x1, y1, x2, y2 = CMD.match(line).captures
    send(cmd, [x1.to_i, y1.to_i], [x2.to_i, y2.to_i])
  end

  def turn_on(p1, p2)
    operate(p1, p2) {|x,y| @lights[x][y] = true }
    self
  end
  alias :"turn on" turn_on

  def turn_off(p1, p2)
    operate(p1, p2) {|x,y| @lights[x][y] = false }
    self
  end
  alias :"turn off" turn_off

  def toggle(p1, p2)
    operate(p1, p2) {|x,y| @lights[x][y] = ! @lights[x][y] }
    self
  end

  def on?
    @lights.reduce(0) {|t,ys| t + ys.count {|y| y} }
  end

  private def operate(p1, p2, &block)
    x1, y1 = *p1
    x2, y2 = *p2

    x1, x2 = [x1, x2].sort
    y1, y2 = [y1, y2].sort

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        block.call(x,y)
      end
    end
  end
end

# star 1

lights = BinaryLights.new

input.each_line do |line|
  lights.command(line)
end

puts "%d lights on"%[lights.on?]

# star 2
class AnalogLights < BinaryLights
  def initialize(x: 1000, y: 1000)
    @lights = Array.new(x) { Array.new(y) { 0 } }
  end

  def command(line)
    cmd, x1, y1, x2, y2 = CMD.match(line).captures
    send(cmd, [x1.to_i, y1.to_i], [x2.to_i, y2.to_i])
  end

  def turn_on(p1, p2)
    operate(p1, p2) {|x,y| @lights[x][y] += 1 }
    self
  end
  alias :"turn on" turn_on

  def turn_off(p1, p2)
    operate(p1, p2) {|x,y| @lights[x][y] = [0, @lights[x][y] - 1].max }
    self
  end
  alias :"turn off" turn_off

  def toggle(p1, p2)
    operate(p1, p2) {|x,y| @lights[x][y] += 2 }
    self
  end

  def on?
    @lights.reduce(0) {|t,ys| t + ys.reduce(:+) }
  end
end

lights = AnalogLights.new

input.each_line do |line|
  lights.command(line)
end

puts "%d total light brightness"%[lights.on?]
