# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# A web worker to evaluate the mandelbrot function for a set of pixels.

# We need MandelbrotCore to do the computations
self.importScripts '../../js/mylibs/mandelbrot-core.js'

# ### Messages

# Listener for messages from parent process
listener = (e) ->
  # Callback to monitor progress
  mandelbrot = new self.MandelbrotCore (progress) =>
    message = JSON.stringify
      message:"progress"
      value:progress
    this.postMessage message
  # Unpack data from call
  data = JSON.parse e.data
  # Calculate escape times
  escapeTimes = mandelbrot.getEscapeTimes data.width, data.height, data.box, data.maxIterations
  # Build a message with the results
  message = JSON.stringify
    message:"success"
    value:escapeTimes
  # Send the success message back to the parent
  this.postMessage message

# Add the listener to the message event, do not `useCapture`
this.addEventListener 'message', listener, false