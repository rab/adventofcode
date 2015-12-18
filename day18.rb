# coding: utf-8
# http://AdventOfCode.com/
# --- Day 18: Like a GIF For Your Yard ---
#
# After the million lights incident, the fire code has gotten stricter: now, at most ten thousand
# lights are allowed. You arrange them in a 100x100 grid.
#
# Never one to let you down, Santa again mails you instructions on the ideal lighting
# configuration. With so few lights, he says, you'll have to resort to animation.
#
# Start by setting your lights to the included initial configuration (your puzzle input). A #
# means "on", and a . means "off".
#
# Then, animate your grid in steps, where each step decides the next configuration based on the
# current one. Each light's next state (either on or off) depends on its current state and the
# current states of the eight lights adjacent to it (including diagonals). Lights on the edge of
# the grid might have fewer than eight neighbors; the missing ones always count as "off".
#
# For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1 through
# 8, and the light marked B, which is on an edge, only has the neighbors marked 1 through 5:
#
# 1B5...
# 234...
# ......
# ..123.
# ..8A4.
# ..765.
#
# The state a light should have next is based on its current state (on or off) plus the number of
# neighbors that are on:
#
# A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
# A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
# All of the lights update simultaneously; they all consider the same current state before moving to the next.
#
# Here's a few steps from an example configuration of another 6x6 grid:
#
# Initial state:
# .#.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####..
#
# After 1 step:
# ..##..
# ..##.#
# ...##.
# ......
# #.....
# #.##..
#
# After 2 steps:
# ..###.
# ......
# ..###.
# ......
# .#....
# .#....
#
# After 3 steps:
# ...#..
# ......
# ...#..
# ..##..
# ......
# ......
#
# After 4 steps:
# ......
# ......
# ..##..
# ..##..
# ......
# ......
# After 4 steps, this example has four lights on.
#
# In your grid of 100x100 lights, given your initial configuration, how many lights are on after 100 steps?
#
# --- Part Two ---
#
# You flip the instructions over; Santa goes on to point out that this is all just an implementation of Conway's Game of Life. At least, it was, until you notice that something's wrong with the grid of lights you bought: four lights, one in each corner, are stuck on and can't be turned off. The example above will actually run like this:
#
# Initial state:
# ##.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####.#
#
# After 1 step:
# #.##.#
# ####.#
# ...##.
# ......
# #...#.
# #.####
#
# After 2 steps:
# #..#.#
# #....#
# .#.##.
# ...##.
# .#..##
# ##.###
#
# After 3 steps:
# #...##
# ####.#
# ..##.#
# ......
# ##....
# ####.#
#
# After 4 steps:
# #.####
# #....#
# ...#..
# .##...
# #.....
# #.#..#
#
# After 5 steps:
# ##.###
# .##..#
# .##...
# .##...
# #.#...
# ##...#
# After 5 steps, this example now has 17 lights on.
#
# In your grid of 100x100 lights, given your initial configuration, but with the four corners
# always in the on state, how many lights are on after 100 steps?
#

require_relative 'input'
day = /day(\d+)\.rb/.match(__FILE__)[1].to_i
input = <<-EOF
.#.#.#
...##.
#....#
..#...
#.#..#
####..
EOF

input = Input.for_day(day)

steps = 1000

class Grid
  def initialize(content)
    @grid = content.split.map{|_|_.split(//)}
  end

  def neighbors(row_index, cell_index)
    rows, cols = self.size
    cells = 0
    if row_index > 0
      row = @grid[row_index-1]
      cells += row[[0,cell_index-1].max .. [cols-1,cell_index+1].min].join.count('#-')
    end
    cells += @grid[row_index][cell_index-1].count('#-') if cell_index > 0
    cells += @grid[row_index][cell_index+1].count('#-') if cell_index < cols-1
    if row_index < rows-1
      row = @grid[row_index+1]
      cells += row[[0,cell_index-1].max .. [cols-1,cell_index+1].min].join.count('#-')
    end
    cells
  end
  private :neighbors

  def step
    @grid.each.with_index do |row, row_index|
      row.each.with_index do |cell, cell_index|
        cell.replace cell.tr('.#',
                             ['.-','.-',
                              '.#',
                              '+#',
                              '.-','.-','.-','.-','.-',
                             ][neighbors(row_index, cell_index)])
      end
    end
    @grid = @grid.map{|row| row.map{|cell| cell.tr('#.+-','#.#.')} }
  end

  def fritz
    @grid[0][0] = '#'
    @grid[0][-1] = '#'
    @grid[-1][0] = '#'
    @grid[-1][-1] = '#'
  end

  def to_s
    @grid.map{|_|_.join}.join("\n")
  end

  def size
    [@grid.size, @grid.map{|_|_.length}.max]
  end

  def lights_on
    @grid.map{|_|_.join.count('#')}.reduce(:+)
  end
end

grid = Grid.new(input)
grid.fritz
top = `tput ho`
steps.times { grid.step; grid.fritz ; print top; print grid.to_s  }
puts grid.lights_on


