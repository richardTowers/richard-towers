# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# A controller for the mandelbrot demo.
class Mandelbrot
  
  # ##Constructor
  
  # Set up dependencies and defaults
  constructor: (@mandelbrotCore, @mandelbrotColors, canvasElement) ->
    # Null check dependencies
    throw "mandelbrotCore is required" unless @mandelbrotCore?
    throw "mandelbrotColors is required" unless @mandelbrotColors?
    throw "A canvas element is required" unless canvasElement?
    
    # Starting bounding box
    @box = 
      top: 1
      left: -2
      bottom: -1
      right: 1
    
    context = canvasElement.getContext '2d'
    throw 'Could not build 2d canvas context in canvas' unless context?
    
    setCanvasSize canvasElement, context
    
    if window.Modernizr.webworkers and window.JSON
      # Use a web worker to do the magic
      worker = new window.Worker '../../js/mylibs/mandelbrot-worker.js'
      @drawSet = () =>
        message = JSON.stringify
          message: "run"
          width: context.canvas.width
          height: context.canvas.height
          box: @box
          maxIterations: 30
        worker.addEventListener 'message',
          ((event) =>
            data = JSON.parse event.data
            switch data.message
              when "progress"
                $('#mandelbrotProgress .bar').css 'width', data.value+'%'
              when "success"
                @mandelbrotColors.drawEscapeTimesInContext(data.value, context)
            ), false
        worker.postMessage message
    else
      # Do the magic ourself :-(
      @drawSet = () =>
        escapeTimes = @mandelbrotCore.getEscapeTimes context.canvas.width, context.canvas.height, @box, 30
        @mandelbrotColors.drawEscapeTimesInContext(escapeTimes, context)
    
    @drawSet()
    
    # Attach resize code to resive event
    $(window).resize ->
      clearTimeout resizeTimer
      resizeTimer = setTimeout (() -> setCanvasSize canvasElement, context), 100 
      return
    
  setCanvasSize = (canvasElement, context) ->
    width = $(canvasElement).parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0
    return

# I think it would be overkill to do this in a factory
core = new window.MandelbrotCore()
colorConverter = new window.ColorConverter()
colors = new window.MandelbrotColors(colorConverter, 30, 30)
canvasElement = document.getElementById('mandelbrot')
mandelbrot = new Mandelbrot(core, colors, canvasElement)