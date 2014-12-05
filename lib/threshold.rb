require 'json'

module Threshold
  class ThresholdCore < Hash
    def initialize
      ObjectSpace.define_finalizer(self, proc { refine; save; })
    end
  end
  
  def load_thresholds map_size
    @thresholds = ThresholdCore.new(JSON.load(File.new("../thresholds.json")), map_size)
  end

  module_function
  def threshold i
    @thresholds[i]
  end
end
