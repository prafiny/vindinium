require_relative 'automaton/core'
require_relative 'automaton/state'
require_relative 'automaton/transition'

module Automaton

module_function

  def def_automaton &block
    @automaton = Core.new self
    @automaton.instance_eval &block
  end

  def method_missing(sym, *args, &block)
    return @automaton.send(sym, *args, &block)
  end
end
