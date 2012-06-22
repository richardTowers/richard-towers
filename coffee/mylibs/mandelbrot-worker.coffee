# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# A web worker to evaluate the mandelbrot function for a set of pixels.

"strict mode"
# We need MandelbrotCore to do the computations
self.importScripts '../../js/libs/require.js'
#self.importScripts '../../js/mylibs/mandelbrot-core.js'
self.require [
    "mandelbrot-core",
  ], (MandelbrotCore) ->
    # ### Messages
    
    # Listener for messages from parent process
    listener = (e) ->
      # Callback to monitor progress
      mandelbrot = new MandelbrotCore (progress) =>
        message = JSON.stringify
          message:"progress"
          value:progress
        this.postMessage message
      # Unpack data from call
      if e.data?
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