# automaton_spec.rb
require_relative '../lib/automaton'

describe Automaton, "#automaton" do
  Robot = Class.new do
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

  it "should handle init state properly" do
    robot = Robot.new 0
    expect(robot.current_state).to eq(:increase)
  end

  it "should do transitions" do
    robot = Robot.new 0
    99.times do
      robot.move
    end
    expect(robot.current_state).to eq(:increase)
    robot.move
    expect(robot.current_state).to_eq(:decrease)
  end

  it "should do behave as specified" do
    robot = Robot.new 0
    robot.move
    expect(robot.n).to eq(1)
    99.times do
      robot.move
    end
    expect(robot.n).to eq(100)
    100.times do
      robot.move
    end
    expect(robot.n).to eq(0)
    100.times do
      robot.move
    end
    expect(robot.n).to eq(-100)
  end
end

