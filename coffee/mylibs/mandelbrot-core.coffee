this.define () ->
  "strict mode"
  class MandelbrotCore
    # ## Constructor
    
    # Necessarily pretty basic as this class could be used in a webworker or a page
    constructor: (@progressCallback) ->
    
    # ## Public Methods
    
    # ### getEscapeTimes
    # Gets the escape time for every pixel
    getEscapeTimes: (width, height, box, maxIterations) ->
      # We want an array of arrays
      escapeTimes = []
      for row in [0..height]
          # Use the fat arrow to bind `this` to the loop function
          do (row) =>
            rowTimes = []
            for column in [0..width]
              do (column) ->
                # Get the real and imaginary coordinates corresponding to this pixel
                real = interpolate column, box.left, box.right, 0, width
                imaginary = interpolate row, box.top, box.bottom, 0, height
                # Calculate the escape time and store the result in our row
                rowTimes.push (getEscapeTimeAtPoint real, imaginary, maxIterations)
            # Store the result for this row
            escapeTimes.push rowTimes
            # If a progress callback was provided use it to update caller on progress
            if this.progressCallback? then this.progressCallback 100*row/height
      return escapeTimes
    
    # ## Private methods
    
    # ### interpolate
    # The linear interpolation function &#x2764;
    interpolate = (x, y0, y1, x0, x1) -> y0 + (x - x0)*((y1 - y0)/(x1-x0))
    
    # ### getEscapeTimeAtPoint
    # Based on the algorithm on [wikipedia](http://en.wikipedia.org/wiki/Mandelbrot_set#For_programmers)
    getEscapeTimeAtPoint = (real, imaginary, maxIteration) ->
      [x, y] = [0, 0]
      for iteration in [0..maxIteration]
        if x*x + y*y < 2*2
          xtemp = x*x - y*y + real
          y = 2*x*y + imaginary
          x = xtemp
        else
          break
      return iteration
      
  return MandelbrotCore