require_relative 'automaton/core'
require_relative 'automaton/state'
require_relative 'automaton/transition'

module Automaton

module_function

  def def_automaton &block
    self.automaton = Core.new &block
  end

  def turn
    self.automaton.act
    self.automaton.evaluate_state
  end

  def current_state
    self.automaton.current_state
  end  

end
