class Mandelbrot
  
  #Constructor
  constructor: () ->
    @topLeft = 
      top: 1
      left: -2
    @bottomRight = 
      bottom: -1
      right: 1
  
  initialise: (canvasId) ->
    context = null
    # Attach initialising code to ready event
    $ ->
      canvas = document.getElementById canvasId
      if canvas?
        context = canvas.getContext '2d'
        setCanvasSize(canvasId, context)
        drawMandelbrot(context)
      return 0
    
    # Attach resize code to resive event
    $(window).resize ->
      clearTimeout resizeTimer
      resizeTimer =
        setTimeout setCanvasSize(canvasId, context), 100 
      return 0
      
  #Private methods
  drawMandelbrot = (context) ->
    width = context.canvas.width
    height = context.canvas.height
    pixels = context.createImageData width, height
    escapeTimes = []
    escapeTimes.push getEscapeTimeAtPixel width, height for row in [1..height] for column in [1..width]
    return 0
  
  getEscapeTimeAtPixel = (real, imaginary) ->
    return 0
        
  setCanvasSize = (canvasId, context) ->
    width = $('#' + canvasId).parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0
    return 0