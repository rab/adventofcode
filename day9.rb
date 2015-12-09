# coding: utf-8
# http://AdventOfCode.com/
# --- Day 9: All in a Single Night ---
#
# Every year, Santa manages to deliver all of his presents in a single night.
#
# This year, however, he has some new locations to visit; his elves have provided him the
# distances between every pair of locations. He can start and end at any two (different) locations
# he wants, but he must visit each location exactly once. What is the shortest distance he can
# travel to achieve this?
#
# For example, given the following distances:
#
# London to Dublin = 464
# London to Belfast = 518
# Dublin to Belfast = 141
# The possible routes are therefore:
#
# Dublin -> London -> Belfast = 982
# London -> Dublin -> Belfast = 605
# London -> Belfast -> Dublin = 659
# Dublin -> Belfast -> London = 659
# Belfast -> Dublin -> London = 605
# Belfast -> London -> Dublin = 982
#
# The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this
# example.
#
# What is the distance of the shortest route?
#
# --- Part Two ---
#
# The next year, just to show off, Santa decides to take the route with the longest distance
# instead.
#
# He can still start and end at any two (different) locations he wants, and he still must visit
# each location exactly once.
#
# For example, given the distances above, the longest route would be 982
# via (for example) Dublin -> London -> Belfast.
#
# What is the distance of the longest route?

require_relative 'input'
day = /day(\d+)\.rb/.match(__FILE__)[1].to_i
input = <<-'EOF'
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
EOF
input = Input.for_day(day)

# star 1
class Graph
  require 'set'

  def initialize
    @graph = Hash.new {|h,k| h[k] = {}}
    @cities = Set.new
  end

  def add_pair(a, b, distance)
    @cities << a << b
    @graph[a][b] = distance
    @graph[b][a] = distance
  end

  def each_route
    @cities.to_a.permutation.each {|route| yield route}
  end

  def route_length(*stops)
    distance = 0
    stops.each_cons(2) do |a,b|
      distance += @graph[a][b]
    end
    distance
  end
end

graph = Graph.new
input.each_line do |pair|
  a, b, distance = /\A(\w+) to (\w+) = (\d+)\z/.match(pair.chomp).captures
  graph.add_pair(a, b, distance.to_i)
end

shortest_route = nil
shortest_distance = nil
# star 2
longest_route = nil
longest_distance = nil

graph.each_route do |route|
  distance = graph.route_length *route
  if shortest_route.nil? || distance < shortest_distance
    shortest_route = route.dup
    shortest_distance = distance
  end
  if longest_route.nil? || distance > longest_distance
    longest_route = route.dup
    longest_distance = distance
  end

end

puts "Shortest #{shortest_route.join(' -> ')} is #{shortest_distance}"
puts "Longest  #{longest_route.join(' -> ')} is #{longest_distance}"
