// Generated by CoffeeScript 1.3.1

/*
 *  Very small helper library to deal with conversions between color systems
 *  Currently supports:
 *    HSV and RGB only
 *  Expected formats:
 *    hsv -> {h: hue, s: saturation, v: value}
 *    rgb -> {r: red, g: green, b: blue}
 *  Expected ranges:
 *    0 <= hue < 360 (values outside this range will wrap)
 *    0 <= saturation, value <= 1 (values will be cropped to fit)
 *    0 <= red, green, blue <= 255 (values will be cropped to fit)
*/


(function() {
  var colorConverter;

  colorConverter = (function() {
    var hsv, hsvToRgb, rgb, rgbToHsv;

    function colorConverter() {}

    colorConverter.prototype.colorToHsv = function(color) {
      if ((color.h != null) && (color.s != null) && (color.v != null)) {
        return color;
      }
      if ((color.r != null) && (color.g != null) && (color.b != null)) {
        return rgbToHsv(color);
      } else {
        throw color + " is not a supported color.";
      }
    };

    colorConverter.prototype.colorToRgb = function(color) {
      if ((color.r != null) && (color.g != null) && (color.b != null)) {
        return color;
      }
      if ((color.h != null) && (color.s != null) && (color.v != null)) {
        return hsvToRgb(color);
      } else {
        throw color + " is not a supported color.";
      }
    };

    rgbToHsv = function(color) {
      var blue, green, hue, max, min, range, red, sat, _ref;
      red = color.r / 255;
      green = color.g / 255;
      blue = color.b / 255;
      max = Math.max(red, green, blue);
      min = Math.min(red, green, blue);
      range = max - min;
      sat = max === 0 ? 0 : range / max;
      switch (max) {
        case min:
          hue = 0;
          break;
        case red:
          hue = (green - blue) / range + ((_ref = green < blue) != null ? _ref : {
            6: 0
          });
          break;
        case green:
          hue = (blue - red) / range + 2;
          break;
        case blue:
          hue = (red - green) / range + 4;
      }
      hue *= 60;
      return hsv(hue, sat, max);
    };

    hsvToRgb = function(color) {
      var chroma, hue, hueSwitch, m, sat, val, x;
      hue = color.h;
      sat = color.s;
      val = color.v;
      if (hue >= 360) {
        hue = hue - Math.floor(hue / 360) * 360;
      } else if (hue < 0) {
        hue = hue + (1 + Math.floor(hue / 360)) * 360;
      }
      sat = Math.max(0, Math.min(1, sat));
      val = Math.max(0, Math.min(1, val));
      chroma = val * sat;
      hueSwitch = hue / 60;
      x = chroma * (1 - Math.abs(hueSwitch % 2 - 1));
      if (sat === 0) {
        color = rgb(0, 0, 0);
      } else if (0 <= hueSwitch && hueSwitch < 1) {
        color = rgb(chroma, x, 0);
      } else if (1 <= hueSwitch && hueSwitch < 2) {
        color = rgb(x, chroma, 0);
      } else if (2 <= hueSwitch && hueSwitch < 3) {
        color = rgb(0, chroma, x);
      } else if (3 <= hueSwitch && hueSwitch < 4) {
        color = rgb(0, x, chroma);
      } else if (4 <= hueSwitch && hueSwitch < 5) {
        color = rgb(x, 0, chroma);
      } else if (4 <= hueSwitch && hueSwitch <= 6) {
        color = rgb(chroma, 0, x);
      }
      m = val - chroma;
      color.r = 255 * (color.r + m);
      color.g = 255 * (color.g + m);
      color.b = 255 * (color.b + m);
      return color;
    };

    rgb = function(red, green, blue) {
      return {
        r: red,
        g: green,
        b: blue
      };
    };

    hsv = function(hue, sat, val) {
      return {
        h: hue,
        s: sat,
        v: val
      };
    };

    return colorConverter;

  })();

}).call(this);
