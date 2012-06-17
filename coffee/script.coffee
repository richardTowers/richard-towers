# @licence This code is [unlicenced](http://unlicense.org/UNLICENSE).

# **script** contains just the calls necessary to set things up.

# Just in case one of the other scripts we've included has been naughty
$ = jQuery

# On the DOM ready event
$ ->
  # **Todo**: Once using [require.js](http://requirejs.org/) most of these should only happen on pages that require them.
  
  # Set up prettyprint for any source that might be on the page.
  window.prettyPrint()
  # Set up [bootstrap tooltips](http://twitter.github.com/bootstrap/javascript.html#tooltips).
  $('[rel=tooltip]').tooltip({placement:'right'})
  
  # **Todo**: Should *definitely* do this using [require](http://requirejs.org/).
  # Mandelbrot set will be drawn in the `#mandelbrot` canvas if there is one.
  if $('#mandelbrot').length
    # Color converter deals with moving between RGB and HSV.
    colorConverter = new window.ColorConverter()
    # Mandelbrot will do all our calculation and drawing
    mandelbrot = new window.Mandelbrot(colorConverter)
    mandelbrot.run 'mandelbrot'