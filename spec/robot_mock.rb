require_relative '../lib/automaton'

class Robot
  include Automaton
  attr_reader :n

  def initialize n
    @n = n

    automaton do
      state :increase, :init do
        transition_to(:decrease) { @n > 100 } 

        behaviour do |c|
          c.n += 1
        end
      end

      state :decrease do
        transition_to(:increase) { @n < -100 }

        behaviour do |c|
          c.n -= 1
        end
      end
    end
    
  end
  def move
    act
  end
end
