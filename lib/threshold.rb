require 'yaml'

module Threshold
  class ThresholdCore
    MaxExploration = 0.2
    def initialize map_size, file, objective
      @file = file
      @config = YAML.load(File.read(file))
      @objective = objective
      @map_size = map_size
      @param = mutate(@config['best_known'][@map_size]) || @config['initial_solution']
    end

    def save
      File.open(@file, 'w') { |file| file.write @param.to_yaml }
    end

    def refine
      score = objective.call
      if score >= (@config['best_score'][@map_size] || 0.)
        @config['best_score'][@map_size] = score
        @config['best_known'][@map_size] = @param
      end
    end
        
    def [] el
      @param[el]
    end

  private
    def mutate thresholds
      thresholds.map do |n|
        n += rand(-MaxExploration..MaxExploration)
        n = 1.0 if n > 1.0
        n = 0.0 if n < 0.0
        n
      end
    end
  end
  
  module_function
  def load_thresholds *args
    @thresholds = ThresholdCore.new(*args)
  end

  def threshold i
    @thresholds[i]
  end

  def finished
    @thresholds.refine
    @thresholds.save
  end
end
