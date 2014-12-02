module Automaton

  class Transition
    def initialize condition, new_state
      @evaluation = condition
      @new_state = new_state
    end

    def evaluate
      condition.call ? @new_state : nil
    end
  end

end
