# A class to deal with coloring mandelbrot plots
window.define () ->
  "strict mode"
  class MandelbrotColors
    
    # ##Constructor
    
    # Assigns our colorConverter and sets up some defaults
    constructor: (@colorConverter, maxIterations, loopEvery) ->
      # Check that the passed in color converter looks kosher
      throw "Cannot construct MandelbrotColors without a colorConverter that imlements colorToRgb({h:,s:,v:})." unless @colorConverter? and @colorConverter.colorToRgb?
      
      # Some preset coloring functions
      @coloringFunctions =
        hue: (i) =>
          @colorConverter.colorToRgb
            h: 360*i/255
            s: 1
            v: 1
        monochrome: (i) ->
          r: i
          g: i
          b: i
      
      # Build the default color lookup table
      colorScheme = generateColorScheme @coloringFunctions.hue
      
      # Default settings
      @settings =
        isBinary: false
        maxIterations: maxIterations()
        loopEvery: loopEvery()
        insideSetColor:
          r: 0
          g: 0
          b: 0
        colorScheme: colorScheme
      
      @cachedImage = new Image()
    
    # ##Public Methods
    
    # ###drawEscapeTimes
    # Takes a canvas context and draws the escape times
    drawEscapeTimesInContext: (escapeTimes, context) =>
      width = context.canvas.width
      height = context.canvas.height
      imageData = context.createImageData width, height
      for row in [0..height]
        do (row) =>
          for column in [0..width]
            do(column) =>
              color = getColor escapeTimes[row][column], @settings
              setPixel imageData, column, row, color.r, color.g, color.b, 255
              return 0
          return 0
      context.putImageData imageData, 0, 0
      dataToCache = context.canvas.toDataURL 'image/png'
      @cachedImage.src = dataToCache
  
    
    # ##Private Methods
    
    # ###generateColorScheme
    # Takes a coloring function and returns an array of 255 colors.
    # This prevents us from having to execute a (potentially) expensive function for every pixel. 
    generateColorScheme = (func) -> func i for i in [0..255]
    
    # ###getColor
    # Get the color corresponding to this escape time
    getColor = (escapeTime, settings) =>
      maxIterations = settings.maxIterations
      if escapeTime >= maxIterations
        return settings.insideSetColor
      else
        if settings.isBinary
          color = settings.colorScheme[0] 
        else
          loopEvery = settings.loopEvery
          index = Math.floor (escapeTime - Math.floor(escapeTime/loopEvery)*loopEvery)*(255/loopEvery)
          color = settings.colorScheme[index]
        return color
    
    # ###setPixel
    # Sets the color and opacity of a specific pixel
    setPixel = (imageData, x, y, r, g, b, a) ->
      index = (x + y * imageData.width) * 4
      imageData.data[index+0] = r
      imageData.data[index+1] = g
      imageData.data[index+2] = b
      imageData.data[index+3] = a
  
  return MandelbrotColors