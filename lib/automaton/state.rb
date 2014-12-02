module Automaton

  class State
    def initialize &block
      @transitions = []
      @behaviour = nil
      @activated = false
      instance_eval(&block)
    end

  private

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

end
