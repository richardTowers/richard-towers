class Mandelbrot
  
  #Constructor
  constructor: (colorConverter)->
    self = this
    
    throw "Cannot construct a Mandelbrot without a colorConverter that imlements colorToRgb({h:,s:,v:})." unless colorConverter? and colorConverter.colorToRgb?
    @_colorConverter = colorConverter
    
    @box = 
      top: 1
      left: -2
      bottom: -1
      right: 1
    
    @maxIterations = 30
    
    if window.Modernizr.webworkers and window.JSON
      # Use a web worker to do the magic
      @worker = new window.Worker '../../js/mylibs/mandelbrot-worker.js'
      @drawSet = (context, maxIterations) -> drawSetWithWorker @worker, context, self.box, maxIterations, @_colorConverter
    else
      # Do the magic ourself :-(
      @drawSet = @drawSetInMainThread
  
  run: (canvasId) ->
    self = this
    canvasElement = document.getElementById canvasId
    throw 'Could not find canvas element ' + canvasId unless canvasElement?
    
    context = canvasElement.getContext '2d'
    throw 'Could not build 2d canvas context in ' + canvasId unless context?
    
    setCanvasSize canvasId, context
    @drawSet context, @maxIterations
    
    mi = $('#maxIterationsButton').click ->
      self.maxIterations = $('#maxIterations').val()
      if self.worker
        self.worker.terminate()
        self.worker = new window.Worker '../../js/mylibs/mandelbrot-worker.js'
      $('#mandelbrotProgress').find('.bar').width '0%'
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
    
    
  drawSetWithWorker = (worker, context, box, maxIterations, colorConverter) ->
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
            drawEscapeTimes context, data.value, maxIterations, colorConverter
            $('#mandelbrotProgress').removeClass 'progress-striped'
            $('#mandelbrotProgress').removeClass 'active'
            $('#mandelbrotProgress').addClass 'progress-success'
          else
            window.alert "Unrecognised message from worker"),
      false
    
    worker.postMessage message
      
  drawSetInMainThread = (context) ->
    return 0
      
  drawEscapeTimes = (context, escapeTimes, maxIterations, colorConverter) ->
    colorScheme = generateColorScheme (i) ->
      colorConverter.colorToRgb
        h: 360*i/255
        s: 1
        v: 1
    
    settings =
      isBinary: false
      maxIterations: maxIterations
      insideSetColor:
        r: 0
        g: 0
        b: 0
      colorScheme: colorScheme
    
    width = context.canvas.width
    height = context.canvas.height
    imageData = context.createImageData width, height
    for row in [0..height]
      do (row) ->
        for column in [0..width]
          do(column) ->
            color = getColor escapeTimes[row][column], settings
            setPixel imageData, column, row, color.r, color.g, color.b, 255
            return 0
        return 0
    context.putImageData imageData, 0, 0
  
  getColor = (escapeTime, settings) ->
    maxIterations = settings.maxIterations
    if escapeTime >= maxIterations
      r: settings.insideSetColor.r
      g: settings.insideSetColor.g
      b: settings.insideSetColor.b
    else
      if settings.isBinary
        color = settings.colorScheme[0] 
      else
        color = settings.colorScheme[Math.floor 255*(escapeTime/maxIterations)]
      r: color.r
      g: color.g
      b: color.b
      
  generateColorScheme = (func) ->
    func i for i in [0..255]
        
  
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