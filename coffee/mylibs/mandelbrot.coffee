class Mandelbrot
  
  #Constructor
  
  constructor: (canvasId) ->
    # Attach initialising code to ready event
    context = null
    $ ->
      canvas = document.getElementById canvasId
      if canvas?
        context = canvas.getContext '2d'
        setCanvasSize(canvasId, context)
        drawMandelbrot(context)
    
    # Attach resize code to resive event
    $(window).resize ->
      clearTimeout resizeTimer
      resizeTimer = 
        setTimeout setCanvasSize(canvasId, context), 100 
      return resizeTimer
      
  
  #Private methods
  drawMandelbrot = (context) ->
    width = context.canvas.width
    height = context.canvas.height
    pixels = context.createImageData width, height
    escapeTimes = []
    #escapeTimes.push getEscapeTimeAtPixel row, column for row in [1..height] for column in [1..width]
    context.fillStyle = 'red'
    context.fillRect 30, 30, 50, 50 
    return escapeTimes
  
  getEscapeTimeAtPixel = (row, column) ->
    return row + column
        
  setCanvasSize = (canvasId, context) ->
    width = $('#' + canvasId).parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0