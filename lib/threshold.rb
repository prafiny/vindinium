module Threshold
  def initialize thresholds, args*
    @thresholds = thresholds
    super args*
  end

  private
  def threshold i
    @thresholds[i]
  end
end
