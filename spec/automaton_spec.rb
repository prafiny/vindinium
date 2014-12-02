# automaton_spec.rb
require_relative 'robot_mock'
robot = Robot.new 0

describe Automaton, "#automaton" do
  it "should handle init state properly" do
    expect(robot.current_state).to eq(:increase)
  end

  it "should do transitions" do
    99.times do
      robot.move
    end
    expect(robot.current_state).to eq(:increase)
    robot.move
    expect(robot.current_state).to_eq(:decrease)
  end

  it "should do behave as specified" do
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

