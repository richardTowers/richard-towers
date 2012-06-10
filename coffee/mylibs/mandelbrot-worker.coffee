this.addEventListener 'message',
  ((e) ->
    data = JSON.parse e.data
    escapeTimes = getEscapeTimes data.width, data.height, data.box, data.maxIterations
    message = JSON.stringify
      message:"success"
      value:escapeTimes
    this.postMessage message),
  false

getEscapeTimes = (width, height, box, maxIterations) ->
  self = this
  escapeTimes = []
  for row in [0..height]
      do (row) ->
        rowTimes = []
        for column in [0..width]
          do (column) ->
            real = interpolate column, box.left, box.right, 0, width
            imaginary = interpolate row, box.top, box.bottom, 0, height
            rowTimes.push (getEscapeTimeAtPoint real, imaginary, maxIterations)
        escapeTimes.push rowTimes
        message = JSON.stringify
          message:"progress"
          value:100*(row/height)
        self.postMessage message
  return escapeTimes

interpolate = (x, y0, y1, x0, x1) -> y0 + (x - x0)*((y1 - y0)/(x1-x0))

getEscapeTimeAtPoint = (real, imaginary, maxIteration) ->
  x = 0
  y = 0
  iteration = 0

  while (x*x + y*y < 2*2  &&  iteration < maxIteration)
    xtemp = x*x - y*y + real
    y = 2*x*y + imaginary
    x = xtemp
    iteration = iteration + 1

  return iteration