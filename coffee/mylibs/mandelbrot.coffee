# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# A controller for the mandelbrot demo.
class Mandelbrot
  
  # ##Constructor
  
  # Set up dependencies and defaults
  constructor: (@mandelbrotCore, @mandelbrotColors, canvasElement) ->
    # Null check dependencies
    throw "mandelbrotCore is required" unless @mandelbrotCore?
    throw "mandelbrotColors is required" unless @mandelbrotColors?
    
    # Starting bounding box
    @box = 
      top: 1
      left: -2
      bottom: -1
      right: 1
    
    if window.Modernizr.webworkers and window.JSON
      # Use a web worker to do the magic
      @worker = new window.Worker '../../js/mylibs/mandelbrot-worker.js'
    else
      # Do the magic ourself :-(

    context = canvasElement.getContext '2d'
    throw 'Could not build 2d canvas context in canvas' unless context?
    
    setCanvasSize canvasElement, context
    
    # Attach resize code to resive event
    $(window).resize ->
      clearTimeout resizeTimer
      resizeTimer = setTimeout (() -> setCanvasSize canvasElement, context), 100 
      return 0
    
  setCanvasSize = (canvasElement, context) ->
    width = $(canvasElement).parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0
    return 0
    
window.Mandelbrot = Mandelbrot