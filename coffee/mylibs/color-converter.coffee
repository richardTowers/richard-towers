# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).
#
# Very small helper library to deal with conversions between color systems.
#
# Currently supports:
#
#   * HSV and RGB only
#
# Expected formats:
#
#   * HSV in the format: `{h: hue, s: saturation, v: value}`
#   * RGB in the format: `{r: red, g: green, b: blue}`
#
# Expected ranges:
#
#   * `0 <= hue < 360` (values outside this range will wrap)
#   * `0 <= saturation, value <= 1` (values will be cropped to fit)
#   * `0 <= red, green, blue <= 255` (values will be cropped to fit)

class ColorConverter
  # ##Public methods
  # ### colorToHsv
  # Takes a color, determines its type from its properties, and returns a new color in HSV
  
  colorToHsv: (color) ->
    if color.h? and color.s? and color.v? then return color
    if color.r? and color.g? and color.b? then return rgbToHsv color
    else throw color + " is not a supported color."
  
  # ### colorToRgb
  # Takes a color, determines its type from its properties, and returns a new color in RGB
  
  colorToRgb: (color) ->
    if color.r? and color.g? and color.b? then return color
    if color.h? and color.s? and color.v? then return hsvToRgb color
    else throw color + " is not a supported color."
  
  # ##Private methods
  # ###rgbToHsv
  # Converts an RGB color to its HSV equivalent using the algorithm from [wikipedia](http://en.wikipedia.org/wiki/HSL_and_HSV#General_approach).
  
  rgbToHsv = (color) ->
    # Scale down the values, we'll work between 0 and 1 internally
    red = color.r/255
    green = color.g/255
    blue = color.b/255
    
    # Get the channels with the maximum and minimum values
    max = Math.max red, green, blue
    min = Math.min red, green, blue
    range = max - min;
    
    # Calculate the saturation. (0 if `r=g=b=0`)
    sat = if max == 0 then 0 else range / max

    switch max
      # If all three channels are the same then the color is achromatic
      when min then hue = 0
      # Calculate the mix of red green and blue
      when red then hue = (green - blue) / range + (green < blue ? 6 : 0)
      when green then hue = (blue - red) / range + 2
      when blue then hue = (red - green) / range + 4
    
    # Scale the hue appropriately
    hue *= 60
    
    # Return an HSV color
    hsv hue, sat, max
  
  # ###hsvToRgb
  # Converts an HSV color to its RGB equivalent using the algorithm from [wikipedia](http://en.wikipedia.org/wiki/HSL_and_HSV#Converting_to_RGB).
  
  hsvToRgb = (color) ->
    hue = color.h
    sat = color.s
    val = color.v
    
    # Rotate the hue if necessary:
    if hue >= 360 then hue = hue - Math.floor(hue/360)*360
    else if hue < 0 then hue = hue + (1+Math.floor(hue/360))*360
    
    # Crop the saturation and value:
    sat = Math.max 0, Math.min(1, sat)
    val = Math.max 0, Math.min(1, val)
    
    # Do the calculation:
    chroma = val * sat
    hueSwitch = hue/60
    x = chroma*(1-Math.abs(hueSwitch%2-1))
    
    if sat == 0 then color = rgb 0, 0, 0
    else if 0 <= hueSwitch and hueSwitch < 1 then color = rgb chroma, x, 0
    else if 1<= hueSwitch and hueSwitch < 2 then color = rgb x, chroma, 0
    else if 2<= hueSwitch and hueSwitch < 3 then color = rgb 0, chroma, x
    else if 3<= hueSwitch and hueSwitch < 4 then color = rgb 0, x, chroma
    else if 4<= hueSwitch and hueSwitch < 5 then color = rgb x, 0, chroma
    else if 4<= hueSwitch and hueSwitch <= 6 then color = rgb chroma, 0, x

    m = val - chroma
    
    color.r = 255 * (color.r + m)
    color.g = 255 * (color.g + m)
    color.b = 255 * (color.b + m)
    return color
  
  # ###Color constructors
  # There's no need to give these their own classes as they're very simple.
  
  rgb = (red, green, blue) ->
    r: red
    g: green
    b: blue
  hsv = (hue, sat, val) ->
    h: hue
    s: sat
    v: val
    
window.ColorConverter = ColorConverter