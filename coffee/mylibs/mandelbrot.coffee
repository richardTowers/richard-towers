class Mandelbrot
  
  #Constructor
  constructor: () ->
    self = this
    @box = 
      top: 1
      left: -2
      bottom: -1
      right: 1
    
    @maxIterations = 100
    
    if window.Modernizr.webworkers and window.JSON
      # Use a web worker to do the magic
      @worker = new window.Worker('../../js/mylibs/mandelbrot-worker.js')
      @drawSet = (context, maxIterations) -> drawSetWithWorker(@worker, context, self.box, maxIterations)
    else
      # Do the magic ourself :-(
      @drawSet = @drawSetInMainThread
  
  run: (canvasId) ->
    self = this
    canvas = document.getElementById canvasId
    if canvas?
      context = canvas.getContext '2d'
      setCanvasSize canvasId, context
      @drawSet context, @maxIterations
      
      mi = $('#maxIterationsButton').click ->
        self.maxIterations = $('#maxIterations').val()
        if self.worker
          self.worker.terminate()
          self.worker = new window.Worker('../../js/mylibs/mandelbrot-worker.js')
        $('#mandelbrotProgress').find('.bar').width('0%')
        self.drawSet context, self.maxIterations
        return 0
        
      
      # Attach resize code to resive event
      $(window).resize ->
        clearTimeout resizeTimer
        resizeTimer = setTimeout (() -> setCanvasSize canvasId, context), 100 
        return 0
    
    
  drawSetWithWorker = (worker, context, box, maxIterations) ->
    progressBar = $('#mandelbrotProgress')
    progressBar.show()
    worker.addEventListener 'message',
      ((e) ->
        data = JSON.parse e.data
        switch data.message
          when "progress"
            progressBar.find('.bar').css 'width', data.value+'%'
          when "success"
            drawEscapeTimes context, data.value
          else
            window.alert "Unrecognised message from worker"),
      false
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
    worker.postMessage message
      
  drawSetInMainThread = (context) ->
    return 0
      
  drawEscapeTimes = (context, escapeTimes) ->
    return 0
  
  
  setCanvasSize = (canvasId, context) ->
    width = $('#' + canvasId).parent().width()
    context.canvas.width = width
    context.canvas.height = width * 2/3.0
    return 0
    
window.Mandelbrot = Mandelbrot