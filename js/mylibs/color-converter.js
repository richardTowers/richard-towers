// Generated by CoffeeScript 1.3.3

window.define(function() {
  "strict mode";

  var ColorConverter;
  ColorConverter = (function() {
    var hsv, hsvToRgb, rgb, rgbToHsv;

    function ColorConverter() {}

    ColorConverter.prototype.colorToHsv = function(color) {
      if ((color.h != null) && (color.s != null) && (color.v != null)) {
        return color;
      }
      if ((color.r != null) && (color.g != null) && (color.b != null)) {
        return rgbToHsv(color);
      } else {
        throw color + " is not a supported color.";
      }
    };

    ColorConverter.prototype.colorToRgb = function(color) {
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
      var chroma, hue, lightness, sat, val, x;
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
      x = chroma * (1 - Math.abs((hue / 60) % 2 - 1));
      lightness = val - chroma;
      if (sat === 0) {
        color = rgb(0, 0, 0);
      } else if (0 <= hue && hue < 60) {
        color = rgb(chroma, x, 0);
      } else if (60 <= hue && hue < 120) {
        color = rgb(x, chroma, 0);
      } else if (120 <= hue && hue < 180) {
        color = rgb(0, chroma, x);
      } else if (180 <= hue && hue < 240) {
        color = rgb(0, x, chroma);
      } else if (240 <= hue && hue < 320) {
        color = rgb(x, 0, chroma);
      } else if (320 <= hue && hue < 360) {
        color = rgb(chroma, 0, x);
      }
      color.r = 255 * (color.r + lightness);
      color.g = 255 * (color.g + lightness);
      color.b = 255 * (color.b + lightness);
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

    return ColorConverter;

  })();
  return ColorConverter;
});
