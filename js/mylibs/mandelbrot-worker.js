// Generated by CoffeeScript 1.3.1
var getEscapeTimeAtPoint, getEscapeTimes, interpolate;

this.addEventListener('message', (function(e) {
  var data, escapeTimes, message;
  data = JSON.parse(e.data);
  escapeTimes = getEscapeTimes(data.width, data.height, data.box, data.maxIterations);
  message = JSON.stringify({
    message: "success",
    value: escapeTimes
  });
  return this.postMessage(message);
}), false);

getEscapeTimes = function(width, height, box, maxIterations) {
  var escapeTimes, row, self, _fn, _i;
  self = this;
  escapeTimes = [];
  _fn = function(row) {
    var column, message, rowTimes, _fn1, _j;
    rowTimes = [];
    _fn1 = function(column) {
      var imaginary, real;
      real = interpolate(column, box.left, box.right, 0, width);
      imaginary = interpolate(row, box.top, box.bottom, 0, height);
      rowTimes.push(getEscapeTimeAtPoint(real, imaginary, maxIterations));
      return 0;
    };
    for (column = _j = 0; 0 <= width ? _j <= width : _j >= width; column = 0 <= width ? ++_j : --_j) {
      _fn1(column);
    }
    escapeTimes.push(rowTimes);
    message = JSON.stringify({
      message: "progress",
      value: 100 * (row / height)
    });
    self.postMessage(message);
    return 0;
  };
  for (row = _i = 0; 0 <= height ? _i <= height : _i >= height; row = 0 <= height ? ++_i : --_i) {
    _fn(row);
  }
  return escapeTimes;
};

interpolate = function(x, y0, y1, x0, x1) {
  return y0 + (x - x0) * ((y1 - y0) / (x1 - x0));
};

getEscapeTimeAtPoint = function(real, imaginary, maxIteration) {
  var iteration, x, xtemp, y;
  x = 0;
  y = 0;
  iteration = 0;
  while (x * x + y * y < 2 * 2 && iteration < maxIteration) {
    xtemp = x * x - y * y + real;
    y = 2 * x * y + imaginary;
    x = xtemp;
    iteration = iteration + 1;
  }
  return iteration;
};