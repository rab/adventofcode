# coding: utf-8
# http://AdventOfCode.com/
# --- Day 7: Some Assembly Required ---
#
# This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates!
# Unfortunately, little Bobby is a little under the recommended age range, and he needs help
# assembling the circuit.
#
# Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number
# from 0 to 65535). A signal is provided to each wire by a gate, another wire, or some specific
# value. Each wire can only get a signal from one source, but can provide its signal to multiple
# destinations. A gate provides no signal until all of its inputs have a signal.
#
# The included instructions booklet describe how to connect the parts together: x AND y -> z means
# to connect wires x and y to an AND gate, and then connect its output to wire z.
#
# For example:
#
# 123 -> x means that the signal 123 is provided to wire x.
# x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
# p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
# NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
#
# Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason,
# you'd like to emulate the circuit instead, almost all programming languages (for example, C,
# JavaScript, or Python) provide operators for these gates.
#
# For example, here is a simple circuit:
#
# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i
# After it is run, these are the signals on the wires:
#
# d: 72
# e: 507
# f: 492
# g: 114
# h: 65412
# i: 65079
# x: 123
# y: 456
#
# In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?
#
# --- Part Two ---
#
# Now, take the signal you got on wire a, override wire b to that signal, and reset the other
# wires (including wire a). What new signal is ultimately provided to wire a?

require_relative 'input'
day = /day(\d+)\.rb/.match(__FILE__)[1].to_i
input = Input.for_day(day)

# input = <<-EOF
# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i
# EOF

# outputs = {
#   d: 72,
#   e: 507,
#   f: 492,
#   g: 114,
#   h: 65412,
#   i: 65079,
#   x: 123,
#   y: 456,
# }

class Wire
  attr_reader :prereqs, :name
  attr_accessor :circuit
  def initialize(connection)
    input, @name = connection.split(/ *-> */,2)
    @name.chomp!

    case input
    when /\A\d+\z/
      @prereqs = []
      @signal = input.to_i
    when /\A\w+\z/
      @prereqs = [input]
      @op = lambda {|a| a }
    when /\A(\w+) AND (\w+)\z/
      @prereqs = [$1, $2]
      @op = lambda {|a,b| a & b }
    when /\A(\w+) OR (\w+)\z/
      @prereqs = [$1, $2]
      @op = lambda {|a,b| a | b }
    when /\A(\w+) LSHIFT (\d+)\z/
      @prereqs = [$1]
      arg = $2.to_i
      @op = lambda {|a| (a << arg) & 0x0FFFF }
    when /\A(\w+) RSHIFT (\d+)\z/
      @prereqs = [$1]
      arg = $2.to_i
      @op = lambda {|a| (a >> arg) }
    when /\ANOT (\w+)\z/
      @prereqs = [$1]
      @op = lambda {|a| (a ^ 0x0FFFF) & 0x0FFFF }
    else
      raise ArgumentError, connection.inspect
    end
  end

  def reset
    @signal = nil unless prereqs.empty?
  end

  def signal
    puts self.inspect if prereqs.nil?
    return @signal if @signal || prereqs.empty?
    inputs = @prereqs.map {|wire_name| circuit.probe(wire_name) }
    @signal = @op.call(*inputs)
  end
end

class Circuit
  def initialize
    @wires = {}
  end

  def add_connection(connection)
    wire = Wire.new(connection)
    wire.circuit = self
    @wires[wire.name] = wire
  end

  def replace(wire_name, connection)
    @wires.delete(wire_name)
    add_connection(connection)
  end

  def probe(wire_name)
    if /\A\d+\z/ =~ wire_name
      wire_name.to_i
    else
      @wires[wire_name].signal
    end
  end

  def reset
    @wires.each do |name,wire|
      wire.reset
    end
  end

end

# %, &, *, **, +, -, -@, /, <, <<, <=, <=>, ==, ===, >, >=, >>, [], ^, abs,
# bit_length, dclone, div, divmod, even?, fdiv, inspect, magnitude, modulo,
# odd?, size, succ, to_f, to_s, zero?, |, ~

circuit = Circuit.new
input.each_line do |connection|
  circuit.add_connection(connection)
end

signal_a = circuit.probe('a')
puts "Wire 'a' has signal %d"%[signal_a]

# puts circuit.inspect
# outputs.each do |name,expected|
#   actual = circuit.probe(name.to_s)
#   puts "#{name} s/b #{expected} #{actual == expected ? '✓' : %{got %s}%[actual.inspect]}"
# end

# star 2
circuit.reset
circuit.replace('b', "%d -> b"%[signal_a])

signal_a = circuit.probe('a')
puts "Now  'a' has signal %d"%[signal_a]
