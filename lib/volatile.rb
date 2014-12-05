module Volatile
  module_function
  def fade
    @volatiles.each do |n|
      instance_variable_set n, nil
    end
  end
  def volatile *args
    args.each do |n|
      @volatiles << ("@" + n.to_s).to_sym
    end
  end
end
