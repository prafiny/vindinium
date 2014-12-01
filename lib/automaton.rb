module Automaton

  def automaton *args, &block
    @automaton = Core.new *args, &block
  end

  def turn
    @automaton.evaluate_state
    @automaton.act
  end

  class Core < Hash
    def initialize &automaton
      super
      @current_state = nil
      automaton.call_instance
    end

    def state name, *args, &block
      self[name] == State.new name, block
      @current_state = name if args.include? :init
    end

    def evaluate_state
      self[@current_state.evaluate_transitions :first].activated!
    end

    def act
      @current_state.act
    end
  end

  class State
    def initialize &block
      @transitions = []
      @behaviour = nil
      @activated = false
      block.call_instance
    end

    def transition opt
      @transitions << Transition.new(lambda opt[:if], opt[:to])
    end

    def behaviour &block
      @behaviour = lambda &block
    end

    def evaluate_transitions rule
      case rule
      when :first
        @transitions.detect { |t| t.evaluate }
      end
    end
  
    def activated!
      @activated = true
    end

    def act
      @behaviour.call
      @activated = false
    end
  end

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
