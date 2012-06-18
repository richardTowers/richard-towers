# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# A web worker to evaluate the mandelbrot function for a set of pixels.

# ### Messages

# Listen for messages from parent process
listener = (e) ->
    # Unpack data from call
    data = JSON.parse e.data
    # Calculate escape times
    escapeTimes = getEscapeTimes data.width, data.height, data.box, data.maxIterations
    # Build a message with the results
    message = JSON.stringify
      message:"success"
      value:escapeTimes
    # Send the success message back to the parent
    this.postMessage message

# Add the listener to the message event, do not `useCapture`
this.addEventListener 'message', listener, false

# ### Functions
# *Todo*: Move these into a separate class with a parameterless contructor

getEscapeTimes = (width, height, box, maxIterations) ->
  self = this
  escapeTimes = []
  for row in [0..height]
      do (row) ->
        rowTimes = []
        for column in [0..width]
          do (column) ->
            real = interpolate column, box.left, box.right, 0, width
            imaginary = interpolate row, box.top, box.bottom, 0, height
            rowTimes.push (getEscapeTimeAtPoint real, imaginary, maxIterations)
        escapeTimes.push rowTimes
        message = JSON.stringify
          message:"progress"
          value:100*(row/height)
        self.postMessage message
  return escapeTimes

interpolate = (x, y0, y1, x0, x1) -> y0 + (x - x0)*((y1 - y0)/(x1-x0))

getEscapeTimeAtPoint = (real, imaginary, maxIteration) ->
  [x, y] = [0, 0]
  for iteration in [0..maxIteration]
    if x*x + y*y < 2*2
      xtemp = x*x - y*y + real
      y = 2*x*y + imaginary
      x = xtemp
    else
      return iteration
  return iteration