class Mandelbrot
  
  #Constructor
  constructor: () ->
    self = this
    @box = 
      top: 1
      left: -2
      bottom: -1
      right: 1
    
    @maxIterations = 30
    
    if window.Modernizr.webworkers and window.JSON
      # Use a web worker to do the magic
      @worker = new window.Worker('../../js/mylibs/mandelbrot-worker.js')
      @drawSet = (context, maxIterations) -> drawSetWithWorker(@worker, context, self.box, maxIterations)
    else
      # Do the magic ourself :-(
      @drawSet = @drawSetInMainThread
  
  run: (canvasId) ->
    self = this
    canvasElement = document.getElementById canvasId
    if canvasElement?
      context = canvasElement.getContext '2d'
      setCanvasSize canvasId, context
      @drawSet context, @maxIterations
      
      mi = $('#maxIterationsButton').click ->
        self.maxIterations = $('#maxIterations').val()
        if self.worker
          self.worker.terminate()
          self.worker = new window.Worker('../../js/mylibs/mandelbrot-worker.js')
        $('#mandelbrotProgress').find('.bar').width('0%')
        $('#mandelbrotProgress').addClass 'progress-striped'
        $('#mandelbrotProgress').addClass 'active'
        $('#mandelbrotProgress').removeClass 'progress-success'
        self.drawSet context, self.maxIterations
        return false
        
      
      # Attach resize code to resive event
      $(window).resize ->
        clearTimeout resizeTimer
        resizeTimer = setTimeout (() -> setCanvasSize canvasId, context), 100 
        return 0
    
    
  drawSetWithWorker = (worker, context, box, maxIterations) ->
    width = context.canvas.width
    height = context.canvas.height
    message = JSON.stringify
      message: "run"
      width:width
      height:height
      box:
        top:box.top
        left:box.left
        bottom:box.bottom
        right:box.right
      maxIterations:maxIterations
      
    worker.addEventListener 'message',
      ((e) ->
        data = JSON.parse e.data
        switch data.message
          when "progress"
            $('#mandelbrotProgress .bar').css 'width', data.value+'%'
          when "success"
            drawEscapeTimes context, data.value, maxIterations
            $('#mandelbrotProgress').removeClass 'progress-striped'
            $('#mandelbrotProgress').removeClass 'active'
            $('#mandelbrotProgress').addClass 'progress-success'
          else
            window.alert "Unrecognised message from worker"),
      false
    
    worker.postMessage message
      
  drawSetInMainThread = (context) ->
    return 0
      
  drawEscapeTimes = (context, escapeTimes, maxIterations) ->
    width = context.canvas.width
    height = context.canvas.height
    imageData = context.createImageData width, height
    for row in [0..height]
      do (row) ->
        for column in [0..width]
          do(column) ->
            color = getColor escapeTimes[row][column], maxIterations
            setPixel imageData, column, row, color.r, color.g, color.b, 255
            return 0
        return 0
    context.putImageData imageData, 0, 0
  
  getColor = (escapeTime, maxIterations) ->
    if escapeTime >= maxIterations
      r: 0
      g: 0
      b: 0
    else
      r: 255-255*(escapeTime/maxIterations)
      g: 255*(escapeTime/maxIterations)
      b: 255*(escapeTime/maxIterations)
  
  setPixel = (imageData, x, y, r, g, b, a) ->
    index = (x + y * imageData.width) * 4
    imageData.data[index+0] = r
    imageData.data[index+1] = g
    imageData.data[index+2] = b
    imageData.data[index+3] = a
  
  setCanvasSize = (canvasId, context) ->
    width = $('#' + canvasId).parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0
    return 0
    
window.Mandelbrot = Mandelbrot