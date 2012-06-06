$ ->
  canvas = document.getElementById 'mandelbrot'
  if canvas?
    context = canvas.getContext '2d'
    window.mandelbrotContext = context
  setCanvasSize(context)
  drawMandelbrot(context)
    
$(window).resize ->
  setCanvasSize(window.mandelbrotContext)
    
drawMandelbrot = (context) ->
    width = context.canvas.width
    height = context.canvas.height
    pixels = context.createImageData(width, height)
    escapeTimes = []
    escapeTimes.push getEscapeTimeAtPixel row, column for row in [1..height] for column in [1..width]
    context.fillStyle = 'red';
    context.fillRect(30, 30, 50, 50);
    escapeTimes

getEscapeTimeAtPixel = (row, column) ->
  return row + column
      

setCanvasSize = (context) ->
    width = $('#mandelbrot').parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0