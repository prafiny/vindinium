module Automaton

  class Core < Hash
    attr_reader :current_state

    def initialize &block
      super()
      @current_state = nil
      instance_eval(&block)
    end

  private
    def state name, &block
      self[name] == State.new(name, &block)
      @current_state = name if self.empty?
    end

    def evaluate_state
      @current_state = self[@current_state.evaluate_transitions :first]
      @current_state.activated!
    end

    def act
      @current_state.act
    end
  end

end
