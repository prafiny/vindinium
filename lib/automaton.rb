module Automaton

  class Automaton < Hash
    attr_reader :current_state

    def initialize &block
      super()
      @current_state = nil
      puts block.class
      instance_eval &block
    end

    def state name, *args, &block
      self[name] == State.new(name, &block)
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
      instance_eval(&block)
    end

    def transition_to *args, &block
      @transitions << Transition.new(lambda block, args.first)
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

  def automaton *args, &block
    @automaton = Automaton.new *args, &block
  end

  def turn
    @automaton.act
    @automaton.evaluate_state
  end

  def current_state
    @automaton.current_state
  end  

end
