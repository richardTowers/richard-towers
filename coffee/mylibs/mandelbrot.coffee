# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

window.require [
    "jquery",
    "libs/modernizr-2.5.3-respond-1.1.0.min",
    "script",
    "libs/knockout-2.1.0",
    "mylibs/mandelbrot-core",
    "mylibs/color-converter",
    "mylibs/mandelbrot-colors"
  ],
  # A controller for the mandelbrot demo.
  ($, modern, script, ko) ->
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
        
        # Attach resize code to resive event
        $(window).resize =>
          clearTimeout resizeTimer
          resizeTimer = setTimeout (() => setCanvasSize canvasElement, context, @mandelbrotColors.cachedImage), 100
          return
        
      setCanvasSize = (canvasElement, context, cachedImage) ->
        width = $(canvasElement).parent().width()
        height = width * 2/3.0
        context.canvas.width = width
        context.canvas.height = height
        if cachedImage?
          context.drawImage cachedImage, 0, 0, width, height
        return
    
    # Define our ViewModel (Todo: separate module?)
    MandelbrotViewModel = () ->
      @maxIterations = ko.observable 30
      @loopColorsEvery = ko.observable 30
      return this
    
    viewModel = new MandelbrotViewModel()
    
    # I think it would be overkill to do this in a factory
    core = new window.MandelbrotCore()
    colorConverter = new window.ColorConverter()
    colors = new window.MandelbrotColors colorConverter, viewModel.maxIterations, viewModel.loopColorsEvery
    canvasElement = document.getElementById 'mandelbrot'
    mandelbrot = new Mandelbrot core, colors, canvasElement
  
    viewModel.drawSet = mandelbrot.drawSet
    viewModel.viewAsImage = () ->
        window.location = colors.cachedImage.src
    ko.applyBindings viewModel
    
    mandelbrot.drawSet()

    return