class MathyStuff
  attr_accessor :percent

  def expensiveMethodWrapper
    @percent = 0.0
    expensiveMethod {|x| @percent = x}
  end
end

Shoes.app do

  @myMathyStuff = MathyStuff.new();
  @window_slot = stack do
    button("Do expensive mathy thing...") do
      @window_slot.toggle
      @progress_slot = flow do
        @progress = progress :width => 1.0
      end
    end
    Thread.new do
        @myMathyStuff.expensiveMethodWrapper
    end
    @animate = animate do
      @progress.fraction = @myMathyStuff.percent
      if @myMathyStuff.percent == 1.0
        @progress_slot.remove
        @window_slot.toggle
        @animate.stop
      end
    end
  end
end
